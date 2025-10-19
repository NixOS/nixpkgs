{
  stdenv,
  lib,
  fetchurl,
  php,
  openssl,
  hiredis,
  libck,
  zstd,
  lz4,
  autoPatchelfHook,
  writeShellScript,
  curl,
  common-updater-scripts,
}:

let
  version = "0.12.0";
  hashes = {
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      hash = {
        "8.1" = "sha256-AH8FzXjIPojCxTQqDChuZPUTDnVPeOeS5a0wNXjlyEk=";
        "8.2" = "sha256-SdivilTHbr28fHaYxK7o1QIT+sWZGHQDjWC2EgtkBbM=";
        "8.3" = "RUnmwI5q4jXHkiRuR/PwqnztEX/7y59DA/L7BelreVk=";
        "8.4" = "sha256-y76rICDyrA/ogRxK+4C3JvJ4ch1fNLBrY01zMmcldnw=";
        "8.5" = "W7BwODGEcRc6E7jpX1nojak7jDV5X+0tjgk32F82wvQ=";
      };
    };
    "aarch64-linux" = {
      platform = "debian-aarch64+libssl3";
      hash = {
        "8.1" = "sha256-Zg1DdzJKfovGwA+cTR5hDQ1Or8oPRrtsyBu3Zt+/6yg=";
        "8.2" = "sha256-tV7aoi9aiUrpOufmN4pQKi0Q0Ad6wrajq9SnaeZGlKg=";
        "8.3" = "sha256-zJN+RSzFXjOB3Uajk1Adrphbz7NAbWMcuB88RRK7SlY=";
        "8.4" = "qvXUg3GqqN3UUtDPQz1H2BiG/b8SomGLyIPR1NIkFUA=";
        "8.5" = "GZZa4a+MfoQPlpIA6zOEnD4UdErh/9fLhMp20rOmGIE=";
      };
    };
    "x86_64-linux" = {
      platform = "debian-x86-64+libssl3";
      hash = {
        "8.1" = "sha256-NTCRrTuiPDbKBauY+9nQm4oJn9TwHQvNfynSKk/bZ7w=";
        "8.2" = "sha256-9GwMHf0GIErr0vZieCH5D5tvJiekpOdBo/u1P30L9lc=";
        "8.3" = "sha256-180n5Naz6dQRCQCj7r0CJhRqfmEHjM7jgkmWRAvyFaY=";
        "8.4" = "nGgvhtuita+rTtns+33xDDEaIXcd3aYiCAClizWtE1E=";
        "8.5" = "wvxZ7jUrqXImzH1LEUmvxpxKL4NE0tAtu9M25P82d0w=";
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
    hiredis
    libck
    openssl
    zstd
    lz4
  ];
  internalDeps = [ php.extensions.session ];
  installPhase = ''
    runHook preInstall
    install -Dm755 relay.so -t $out/lib/php/extensions
  ''
  + (
    if stdenv.hostPlatform.isDarwin then
      let
        args =
          lib.strings.concatMapStrings
            (v: " -change ${v.name}" + " ${lib.strings.makeLibraryPath [ v.value ]}/${baseNameOf v.name}")
            (
              with lib.attrsets;
              [
                (nameValuePair "/opt/homebrew/opt/hiredis/lib/libhiredis.1.1.0.dylib" hiredis)
                (nameValuePair "/opt/homebrew/opt/hiredis/lib/libhiredis_ssl.dylib.1.1.0" hiredis)
                (nameValuePair "/opt/homebrew/opt/concurrencykit/lib/libck.0.dylib" libck)
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
      NEW_VERSION=$(curl --silent https://builds.r2.relay.so/meta/builds | sort -V | tail -n1 | cut -c2-)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for source in ${lib.concatStringsSep " " (builtins.attrNames finalAttrs.passthru.updateables)}; do
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION" --ignore-same-version --ignore-same-hash --print-changes
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
