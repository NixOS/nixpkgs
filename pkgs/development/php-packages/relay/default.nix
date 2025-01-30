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
  version = "0.10.0";
  hashes = {
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      hash = {
        "8.1" = "sha256-aEuYKo31dKV7TSOeKt4BSShstNxfS4EdibJ2279XTbg=";
        "8.2" = "sha256-tjE+bAiVWYh6od8rW7flZ6ajMGxMJszw7H055VtDJsc=";
        "8.3" = "1czi5sfic13068hj8x1fgzkwsykbrr1g5ifc53zxds5vqywa74d7";
        "8.4" = "sha256-QUryARS5omADR3kEykCnoK4IFau1RpTQKDcCJ+lN/SY=";
        "8.5" = "0k33qfrlxb9v0d15mdzzqsgdcik8z65nv1q9spn7ibdxg6clzykj";
      };
    };
    "aarch64-linux" = {
      platform = "debian-aarch64+libssl3";
      hash = {
        "8.1" = "sha256-Aq4jZyo5JzVtJM96HzzsnSnx8jOCAmHB6f3eo1922gs=";
        "8.2" = "sha256-Yd1bWEsRXuG30aDE9lCgLa/qlnXyeMehR3ROF0uAVTY=";
        "8.3" = "sha256-j6qhr04zQDi+mQh968nVxlTGEnhQobI7kG8DK35sCiM=";
        "8.4" = "0av8g5n4h3g2r4jbv3v1bwyx256z58wyygnd5jk4jzpx0ik2c1vv";
        "8.5" = "1aav4lh29d507av5ydxjvgm20fljl5lwdljdyq3038g3gi06yjaj";
      };
    };
    "x86_64-linux" = {
      platform = "debian-x86-64+libssl3";
      hash = {
        "8.1" = "sha256-306YMQr/UCJ+LOgEdzmqAPVBvbq2TDXnvSxdh4u6Nbc=";
        "8.2" = "sha256-tapNth0vqNlCh1c3HryIYOs+V9jadTV1rMvoz+tVbeI=";
        "8.3" = "sha256-f0eKpHcdiOHM55VuPYq+AJnbIwnBDLaECv+hYMBh0dw=";
        "8.4" = "05h2ikl0ymd2xmqifvv700xazhllsm234s41ipdgfwdj7zyxv58s";
        "8.5" = "0frnd7y3zvj8vq10r4479lx04lj606xzd3hjg61lg5mq65i6xih0";
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
  installPhase =
    ''
      runHook preInstall
      install -Dm755 relay.so -t $out/lib/php/extensions
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
