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
  version = "0.40.0";
  hashes = {
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      hash = {
        "8.1" = "sha256-pwqus2P17DirEGqwbe5CqlIZ+InPrIHbUUbcgLli8rc=";
        "8.2" = "sha256-IeoOYVnp0sWD+Ww/d8DwDemqXv/6neEWE3g2txHEuEg=";
        "8.3" = "OQAErtNtCIpNmz2YbfhLJ9ueH7mhZa6j1YtcuH00Ob8=";
        "8.4" = "sha256-WP283JJfXQTnfbnyLfs0j8IIcdDGflCFtV0WxBV/JLU=";
        "8.5" = "0zH1RD2Uq5uG4TnUsYzsYgUdUshsKNU0kzbdNG77sd8=";
      };
    };
    "aarch64-linux" = {
      platform = "debian-aarch64+libssl3";
      hash = {
        "8.1" = "sha256-r6rV05ZLsi2SvFqONtYk2IIrkdbTZqsClruTMpcOOas=";
        "8.2" = "sha256-SsHqRS3Bq4N10c06zEoVZXTv5+bfkcDgCRdntcoyD/k=";
        "8.3" = "sha256-yQunez9xOyhGYqFKHKWtdK8BiGPz3JIyDnsfqGthIYs=";
        "8.4" = "bC/67qQxe/Zy027r8c7tWr6S6Seeh+lbjYEl+cE7HNw=";
        "8.5" = "3KWlZxbO8u5hpN/PsKzgCbNUhWHb56SqgNwTL8iHtSs=";
      };
    };
    "x86_64-linux" = {
      platform = "debian-x86-64+libssl3";
      hash = {
        "8.1" = "sha256-KgyAPCLLtmeMa5X3Akuf0nR51aSQS6+RpNYO3U4Zdp0=";
        "8.2" = "sha256-zSl141iQ3Vfb5JmeRacFZhBcfEKQuW9rld9O2c8HRvU=";
        "8.3" = "sha256-kdd4k6xdbbNuIk/DBTufxqH8j+4Z2xgzG4Z/c7PfKFs=";
        "8.4" = "jteJPpdxFSBljS81Jn9x6cLLn3iLVpqeGb3qecWFw4c=";
        "8.5" = "uFZj/cDsd6LhIeaj3IdB3Kl9btnkS/eEVfLdYhh4Mus=";
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
