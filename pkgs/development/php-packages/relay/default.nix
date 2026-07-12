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
  version = "0.30.0";
  hashes = {
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      hash = {
        "8.1" = "sha256-71TLrF9HvuocMLei89bGIibJIC1sD59RB9Vb6FBS49U=";
        "8.2" = "sha256-WFrJ0+gun1qs77s3URFTha/tZA8gSeqlGLT26twnjko=";
        "8.3" = "fiduW1NKScDDY3k3lvw98r8KqaD0jPR4En8dNvdglFA=";
        "8.4" = "sha256-SQ9+/zD6n49e2/9nH6hotyIJ/xsQMX5A78hFTPK4/hg=";
        "8.5" = "+n+fE5soEbruH+L35B+bapU/Z7rSjjOD/4BgRmr3MVc=";
      };
    };
    "aarch64-linux" = {
      platform = "debian-aarch64+libssl3";
      hash = {
        "8.1" = "sha256-hetG8fEmMJccYWMQwPb3hml5thNeY2L6Y4gCDQmbDlo=";
        "8.2" = "sha256-HufvcT4QSkuoxDcaCWD+hmG1fORyTUBh1Vsfnv7krng=";
        "8.3" = "sha256-LV4coud7YNqB+s1sHoKXNVLAUrLjDMDpulS9fGVXDsg=";
        "8.4" = "em1nZgGD1fAtvMxVeJBU4RZaA71/qMVLi0KCRAbilpM=";
        "8.5" = "d0f3PzvZZn1KmXy1Gm0gm5f3f58kt+/LTc3yWZqto2I=";
      };
    };
    "x86_64-linux" = {
      platform = "debian-x86-64+libssl3";
      hash = {
        "8.1" = "sha256-La/TQDnQ0hqNhPMtLlwfw5cKtXCpjxBMTd6yvZM2O2M=";
        "8.2" = "sha256-+FavbnliF071lWFU55rhFNq6X2wpW9mHSstwQQTbnwQ=";
        "8.3" = "sha256-G6nfKMObVMtY45J7DaKg0LdHwV+lfCUa1Pkfp66+apY=";
        "8.4" = "x9YXGxtqN3EL1lWCqAkIKKrO0b40BFalO6GExhF3p4c=";
        "8.5" = "8hU5Ft9i3L6pf2XY7rRLmSbQmZ3z1wjI+7sjiq/GHUU=";
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
      let
        args =
          lib.concatMapStrings
            (
              v:
              let
                targetName = if v ? to then v.to else builtins.baseNameOf v.from;
              in
              " -change ${v.from} ${lib.strings.makeLibraryPath [ v.pkg ]}/${targetName}"
            )
            [
              {
                from = "/opt/homebrew/opt/concurrencykit/lib/libck.0.dylib";
                pkg = libck;
              }
              {
                from = "/opt/homebrew/opt/openssl@3/lib/libssl.3.dylib";
                pkg = openssl;
              }
              {
                from = "/opt/homebrew/opt/openssl@3/lib/libcrypto.3.dylib";
                pkg = openssl;
              }
              {
                from = "/opt/homebrew/opt/zstd/lib/libzstd.1.dylib";
                pkg = zstd;
              }
              {
                from = "/opt/homebrew/opt/lz4/lib/liblz4.1.dylib";
                pkg = lz4;
              }
              {
                from = "/opt/homebrew/opt/hiredis/lib/libhiredis.1.3.0.dylib";
                pkg = hiredis;
                to = "libhiredis.1.1.0.dylib";
              }
              {
                from = "/opt/homebrew/opt/hiredis/lib/libhiredis_ssl.1.3.0.dylib";
                pkg = hiredis;
                to = "libhiredis_ssl.dylib.1.1.0";
              }
            ];
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
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
