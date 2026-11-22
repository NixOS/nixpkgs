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
  runCommand,
  curl,
  common-updater-scripts,
}:

let
  version = "0.61.1";
  hashes = {
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      hash = {
        "8.1" = "sha256-9QRkBKQ5p6R9DaiWa5wWjRvzXwVl514Ywt9qN9XhhDk=";
        "8.2" = "sha256-JI/ibOEMHbZZ6oTFLMWHKoJlfShzssgcPO8aOZOMDl0=";
        "8.3" = "kyvnlPIuldZa3WmC7eoou7jBrCqi+ZNkvwCl3Yzgwd0=";
        "8.4" = "sha256-YoOpHY53pPJ4d4dhrM7/OiNEhTlgOCraPxgvOHdxQ+w=";
        "8.5" = "86WH9u/+5A5qVEbzUbFHbhpoXRXcE7J+UGdDHq6qjYs=";
      };
    };
    "aarch64-linux" = {
      platform = "debian-aarch64+libssl3";
      hash = {
        "8.1" = "sha256-Bhlp5sknuwYj89t8ZV5pI4gVC4xtCocfhUp54MSKwQ0=";
        "8.2" = "sha256-tNriT4trLc0AjOr+4verVQcCj4pNFB0vK5Yp5rbCf/I=";
        "8.3" = "sha256-IiFXTjC1tGiC7mGulAeX81RU8Pg6U+66ld6ks5mdqcA=";
        "8.4" = "DFjV43ZhBV7JWtiHSR2btxG8izpH60DplYetyEvKhCQ=";
        "8.5" = "9x84xOJ3QMC0CP0EyGqA3cOqT8e+vK3hcFrfdnP6lME=";
      };
    };
    "x86_64-linux" = {
      platform = "debian-x86-64+libssl3";
      hash = {
        "8.1" = "sha256-zkymXwjIITXkoKIUKHtOmTf8Nu+9JCMKGF9sAUQtcEk=";
        "8.2" = "sha256-S5Tw19mKF1shWHn7+FS63KqEPVh/RpDYOqPYOq5CB0s=";
        "8.3" = "sha256-tNYh6bzacO1AEvIALML3NJbXJvRtdi7GeQQ4VMkJkaU=";
        "8.4" = "1FAkSPvs0ykyxRSWtv1nAaY7CSoe200KpnX2y4MuuP0=";
        "8.5" = "XqzYRp6VimTLfKMCeNGFV2TRM5JgSPeaeaC2iqt2gs0=";
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
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Temporary patch as relay isn't compatible with the latest version of hiredis out of
    # the box.
    patchelf \
      --replace-needed libhiredis.so.1.1.0 libhiredis.so.1 \
      --replace-needed libhiredis_ssl.so.1.1.0 libhiredis_ssl.so.1 \
        relay.so
  ''
  + ''
    install -Dm755 relay.so -t $out/lib/php/extensions
  ''
  + (
    if stdenv.hostPlatform.isDarwin then
      # fixDarwinDylibNames can't be used here because we need to completely remap .dylibs, not just add
      # absolute paths. Rather than hardcoding the Homebrew paths and versions relay.so happens to be
      # linked against (which silently goes stale whenever relay or one of these libraries updates),
      # discover the actual references via otool and remap them by matching their basename.
      ''
        for dylib in $(otool -L $out/lib/php/extensions/relay.so | tail -n +2 | awk '{print $1}' | grep '^/opt/homebrew/'); do
          base=$(basename "$dylib")
          case "$base" in
            libhiredis_ssl.*) dir="${lib.makeLibraryPath [ hiredis ]}" ;;
            libhiredis.*) dir="${lib.makeLibraryPath [ hiredis ]}" ;;
            libssl.*) dir="${lib.makeLibraryPath [ openssl ]}" ;;
            libcrypto.*) dir="${lib.makeLibraryPath [ openssl ]}" ;;
            libzstd.*) dir="${lib.makeLibraryPath [ zstd ]}" ;;
            liblz4.*) dir="${lib.makeLibraryPath [ lz4 ]}" ;;
            libck.*) dir="${lib.makeLibraryPath [ libck ]}" ;;
            *)
              echo "relay.so references unrecognized Homebrew library $dylib; add a mapping for it" >&2
              exit 1
              ;;
          esac
          install_name_tool -change "$dylib" "$dir/$base" $out/lib/php/extensions/relay.so
        done
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
    tests.smokeTest = runCommand "php-relay-smoke-test" { } ''
      ${lib.getExe php} \
        -d extension=${finalAttrs.finalPackage}/lib/php/extensions/relay.so \
        -r 'exit(extension_loaded("relay") ? 0 : 1);'
      touch $out
    '';

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

  meta = {
    description = "Next-generation Redis extension for PHP";
    changelog = "https://github.com/cachewerk/relay/releases/tag/v${version}";
    homepage = "https://relay.so/";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      tillkruss
      ostrolucky
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
