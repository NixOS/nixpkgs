{
  stdenv,
  lib,
  fetchurl,
  php,
  openssl,
  hiredis,
  zstd,
  lz4,
  autoPatchelfHook,
  writeShellScript,
  curl,
  common-updater-scripts,
}:

let
  version = "0.7.0";
  hashes = {
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      hash = {
        "8.0" = "sha256-pd/9TWZPgAfmVM0/QVYRHu5k4gANcxCSnfAl38irO0Y=";
        "8.1" = "sha256-OpxE/nu8MZedTmKGQeyJm36pyyHlRpW11avuGcnGP68=";
        "8.2" = "sha256-+CMPdXZotUr43Qda1FwGpuWPEE1K4RuBNE9fiokAtoY=";
        "8.3" = "sha256-lbKVxOd5gK5VDGnJ42w7L5DFKsBQDZXgEZLR/Y0gP88=";
      };
    };
    "aarch64-linux" = {
      platform = "debian-aarch64+libssl3";
      hash = {
        "8.0" = "sha256-NfeC3p0YLYz3NbjzjMRRuzMsnYe9JRwlBjddAG2WV7g=";
        "8.1" = "sha256-kvO0PE3BSgFSfe1zHh3WnygQfVV+5V0YFfClBim1Kj4=";
        "8.2" = "sha256-illxRqqwMKVNAp6BD+mktKDccM7B/Q1W1KF9UB6aMUQ=";
        "8.3" = "sha256-QdB7g+ePJU8qt/BVo1CFnQ2vfkqR29WueBy3dLOOaR0=";
      };
    };
    "x86_64-darwin" = {
      platform = "darwin-x86-64";
      hash = {
        "8.0" = "sha256-rd3pt2N22bF4a8OOwksI7KJjR91IoxHwk3LcKuHSpV0=";
        "8.1" = "sha256-Y/moZrBe4rooQBSQKS8vPCTjviHKy4O7d4T1kD3udC4=";
        "8.2" = "sha256-H3EWFk/ZmE+fSU98nLHyq1p1vtU/TYp28OzNLox6kYY=";
        "8.3" = "sha256-vZTarrauo7U2JLOXUCwmu2h+vBtWZpm0Q39KkuLyVgY=";
      };
    };
    "x86_64-linux" = {
      platform = "debian-x86-64+libssl3";
      hash = {
        "8.0" = "sha256-jq/nHC9IGevYBqbM08nF71P9jH6z4NB8s1NdjHOfXQA=";
        "8.1" = "sha256-vbFONNHpuSTQsZMrAIdGEoBl5ySchcFkSuhW5uZKbWg=";
        "8.2" = "sha256-mXUAMkxwtuPZbIyCybBcxpmaBplr5h59pZEdgJ3PWtA=";
        "8.3" = "sha256-YL0P8GtFkV0cmJX1y6wd/HtA0LFzeuOcKDLUCagxHxE=";
      };
    };
  };

  makeSource =
    { system, phpMajor }:
    fetchurl {
      url =
        "https://builds.r2.relay.so/v${version}/relay-v${version}-php"
        + phpMajor
        + "-"
        + hashes.${system}.platform
        + ".tar.gz";
      sha256 =
        hashes.${system}.hash.${phpMajor}
          or (throw "Unsupported PHP version for relay ${phpMajor} on ${system}");
    };
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "relay";
  extensionName = "relay";

  src = makeSource {
    system = stdenv.hostPlatform.system;
    phpMajor = lib.versions.majorMinor php.version;
  };
  nativeBuildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ autoPatchelfHook ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    openssl
    zstd
    lz4
  ];
  installPhase =
    ''
      runHook preInstall

      mkdir -p $out/lib/php/extensions
      cp relay-pkg.so $out/lib/php/extensions/relay.so
      chmod +w $out/lib/php/extensions/relay.so
    ''
    + (
      if stdenv.hostPlatform.isDarwin then
        let
          args =
            lib.strings.concatMapStrings
              (
                v:
                " -change ${v.name}" + " ${lib.strings.makeLibraryPath [ v.value ]}/${builtins.baseNameOf v.name}"
              )
              (
                with lib.attrsets;
                [
                  (nameValuePair "/opt/homebrew/opt/hiredis/lib/libhiredis.1.1.0.dylib" hiredis)
                  (nameValuePair "/opt/homebrew/opt/hiredis/lib/libhiredis_ssl.dylib.1.1.0" hiredis)
                  (nameValuePair "/opt/homebrew/opt/openssl@3/lib/libssl.3.dylib" openssl)
                  (nameValuePair "/opt/homebrew/opt/openssl@3/lib/libcrypto.3.dylib" openssl)
                  (nameValuePair "/opt/homebrew/opt/zstd/lib/libzstd.1.dylib" zstd)
                  (nameValuePair "/opt/homebrew/opt/lz4/lib/liblz4.1.dylib" lz4)
                ]
              );
        in
        # fixDarwinDylibNames can't be used here because we need to completely remap .dylibs, not just add absolute paths
        ''
          install_name_tool${args} $out/lib/php/extensions/relay.so
        ''
      else
        ""
    )
    + ''
      # Random UUID that's required by the extension. Can be anything, but must be different from default.
      sed -i "s/00000000-0000-0000-0000-000000000000/aced680f-30e9-40cc-a868-390ead14ba0c/" $out/lib/php/extensions/relay.so
      chmod -w $out/lib/php/extensions/relay.so

      runHook postInstall
    '';

  passthru = {
    updateScript = writeShellScript "update-${finalAttrs.pname}" ''
      set -o errexit
      export PATH="$PATH:${
        lib.makeBinPath [
          curl
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://builds.r2.relay.so/meta/builds | tail -n1 | cut -c2-)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for source in ${lib.concatStringsSep " " (builtins.attrNames finalAttrs.passthru.updateables)}; do
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION" --ignore-same-version
      done
    '';

    # All sources for updating by the update script.
    updateables =
      builtins.listToAttrs
        # Collect all leaf attributes (containing hashes).
        (
          lib.collect (attrs: attrs ? name)
            # create an attr containing
            (
              lib.mapAttrsRecursive (
                path: _value:
                lib.nameValuePair (builtins.replaceStrings [ "." ] [ "_" ] (lib.concatStringsSep "_" path)) (
                  finalAttrs.finalPackage.overrideAttrs (attrs: {
                    src = makeSource {
                      system = builtins.head path;
                      phpMajor = builtins.head (builtins.tail (builtins.tail path));
                    };
                  })
                )
              ) (lib.filterAttrsRecursive (name: _value: name != "platform") hashes)
            )
        );
  };

  meta = with lib; {
    description = "Next-generation Redis extension for PHP";
    changelog = "https://github.com/cachewerk/relay/releases/tag/v${version}";
    homepage = "https://relay.so/";
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [
      tillkruss
      ostrolucky
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
