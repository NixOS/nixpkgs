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
  version = "0.60.0";
  hashes = {
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      hash = {
        "8.1" = "sha256-OYLYmPZpDry/CPYuxDIPYSou4NPpUDUudHDLn67i0+k=";
        "8.2" = "sha256-/eNGsk/XCpjjs+MLN8QugMrHOEVVmZRIJW/Gehfcp7g=";
        "8.3" = "QSc7Yz8ytZoV0SWRVckjdFJKnazVV3Qu+okQJyqxKjI=";
        "8.4" = "sha256-BspJ9uxF+n3R3kHRxS2XwahipnZ5TkgH5EhGEJv6faI=";
        "8.5" = "SL0ZZScUmYkyP6iEoBETmwVIHZ8vdC93WhtzabL/hY4=";
      };
    };
    "aarch64-linux" = {
      platform = "debian-aarch64+libssl3";
      hash = {
        "8.1" = "sha256-T/SxM0T2rqRG7w93Uob/OWkAF9C7CqMftHZW7mSK6zo=";
        "8.2" = "sha256-Tdq6hEtaCcPx0ANkuCONC9QUvfGCw4z4rJsqWO87tgo=";
        "8.3" = "sha256-JBZLEgnC0CQxBdqP0lKhLFtqNpDabWqtOtOJ8YeSYx4=";
        "8.4" = "N0WoAWZPVwCn1fSq9II+zwvB5t7B8fL/jG+vmlEhJOE=";
        "8.5" = "iJg+tdoVzIIoqfjXolqKYgV987PV791f0DQRIkoefjM=";
      };
    };
    "x86_64-linux" = {
      platform = "debian-x86-64+libssl3";
      hash = {
        "8.1" = "sha256-lSt6LcFDEei5BWUyYzGJU9EZnJ4z9Mc+JuglIDWAQp4=";
        "8.2" = "sha256-b9vqxRiLr0/Orw9XL6F9TDCwZ1HqxjMVw+ukIikjeGo=";
        "8.3" = "sha256-KIh4WOxamr1rwTOniVW/XXDsUDADx3WOD6LiGLBFxgk=";
        "8.4" = "upn4ZRTxORZq2e7kKsWe1y0+tjUDVFVXOq2V+EXio2g=";
        "8.5" = "HjunWyS7ghFjMbiICc+jAwtDvVnCoYkB5s2NdvN/ZT0=";
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
