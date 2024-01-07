{ stdenv
, lib
, fetchurl
, php
, openssl
, hiredis
, zstd
, lz4
, autoPatchelfHook
, writeShellScript
, curl
, common-updater-scripts
}:

let
  version = "0.6.8";
  hashes = {
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      hash = {
        "8.0" = "sha256-DDn5JcRux8DN1728cqMWL7eMwueiY+jO/+fw2+ND394=";
        "8.1" = "sha256-4r954EKFUA45G55MpnnKcYONCNe45dIffiygs6r8OOI=";
        "8.2" = "sha256-qB2IWSsyAKzbUxjt2nz5uLp7PkgPPna1mEBqvz8oTHc=";
        "8.3" = "sha256-0s+4zNknH8lEfGS8oU3JjVEuX3mZEo9AULE0hlv11mQ=";
      };
    };
    "aarch64-linux" = {
      platform = "debian-aarch64+libssl3";
      hash = {
        "8.0" = "sha256-tLrampq1BBrhC+F/v2vcNBJp+16wzjHC8CGFKSswPUo=";
        "8.1" = "sha256-DQG3maP9ImwSCTEmP152l5wr7A964lg9kNFAmVQhPqA=";
        "8.2" = "sha256-3Ygb2J+MFL+H1zsepBaQKg/ybqgXVwFWt2QrNRctT8o=";
        "8.3" = "sha256-MKpN09+Ai9NFARUEL+pkxQxbpRpFTx78als8ViXMdB8=";
      };
    };
    "x86_64-darwin" = {
      platform = "darwin-x86-64";
      hash = {
        "8.0" = "sha256-jYnhJowVgryKSec+rOfyBiH2gZyasr1h1I+sjPiLods=";
        "8.1" = "sha256-VKvVo6so0NOfiq7JjnanBEUDa1Iqmkn9egKnOJSCHTg=";
        "8.2" = "sha256-WXWhSljy199UbZiEjfC50XvnKfVEU54lPa6e2+jCqiQ=";
        "8.3" = "sha256-CrJoONSm0aXlBWjsRqAJC39qB4tHkMuLAvM5d847DsE=";
      };
    };
    "x86_64-linux" = {
      platform = "debian-x86-64+libssl3";
      hash = {
        "8.0" = "sha256-kzPlotJWsUIhYUFUwcXEBGv5eNfCNLDNgrs+IqZPH5c=";
        "8.1" = "sha256-QBnKHXBW2XpD4GvphzyMPiIrOfs9pzyG2Fv/VyV+h9k=";
        "8.2" = "sha256-yk+dkULtWVIccKurBdT96HOPbW8Q9l44iYpAAcoZYog=";
        "8.3" = "sha256-MpMupGFGxipghoA57EOytSsDsm9b25rc/VPIza+QMfM=";
      };
    };
  };

  makeSource = { system, phpMajor }: fetchurl {
    url = "https://builds.r2.relay.so/v${version}/relay-v${version}-php"
      + phpMajor + "-" + hashes.${system}.platform + ".tar.gz";
    sha256 = hashes.${system}.hash.${phpMajor} or (throw "Unsupported PHP version for relay ${phpMajor} on ${system}");
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
  nativeBuildInputs = lib.optionals (!stdenv.isDarwin) [
    autoPatchelfHook
  ];
  buildInputs = lib.optionals (!stdenv.isDarwin) [
    openssl
    zstd
    lz4
  ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/php/extensions
    cp relay-pkg.so $out/lib/php/extensions/relay.so
    chmod +w $out/lib/php/extensions/relay.so
  '' + (if stdenv.isDarwin then
    let
      args = lib.strings.concatMapStrings
        (v: " -change ${v.name}" + " ${lib.strings.makeLibraryPath [ v.value ]}/${builtins.baseNameOf v.name}")
        (with lib.attrsets; [
          (nameValuePair "/opt/homebrew/opt/hiredis/lib/libhiredis.1.1.0.dylib" hiredis)
          (nameValuePair "/opt/homebrew/opt/hiredis/lib/libhiredis_ssl.dylib.1.1.0" hiredis)
          (nameValuePair "/opt/homebrew/opt/openssl@3/lib/libssl.3.dylib" openssl)
          (nameValuePair "/opt/homebrew/opt/openssl@3/lib/libcrypto.3.dylib" openssl)
          (nameValuePair "/opt/homebrew/opt/zstd/lib/libzstd.1.dylib" zstd)
          (nameValuePair "/opt/homebrew/opt/lz4/lib/liblz4.1.dylib" lz4)
        ]);
    in
    # fixDarwinDylibNames can't be used here because we need to completely remap .dylibs, not just add absolute paths
    ''
      install_name_tool${args} $out/lib/php/extensions/relay.so
    ''
  else
    "") + ''
    # Random UUID that's required by the extension. Can be anything, but must be different from default.
    sed -i "s/00000000-0000-0000-0000-000000000000/aced680f-30e9-40cc-a868-390ead14ba0c/" $out/lib/php/extensions/relay.so
    chmod -w $out/lib/php/extensions/relay.so

    runHook postInstall
  '';

  passthru = {
    updateScript = writeShellScript "update-${finalAttrs.pname}" ''
      set -o errexit
      export PATH="$PATH:${lib.makeBinPath [ curl common-updater-scripts ]}"
      NEW_VERSION=$(curl --silent https://builds.r2.relay.so/meta/builds | tail -n1 | cut -c2-)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for source in ${lib.concatStringsSep " " (builtins.attrNames finalAttrs.passthru.updateables)}; do
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "0" "sha256-${lib.fakeSha256}"
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION"
      done
    '';

    # All sources for updating by the update script.
    updateables =
      builtins.listToAttrs
        # Collect all leaf attributes (containing hashes).
        (lib.collect
          (attrs: attrs ? name)
          # create an attr containing
          (lib.mapAttrsRecursive
            (
              path: _value:
                lib.nameValuePair
                  (builtins.replaceStrings [ "." ] [ "_" ] (lib.concatStringsSep "_" path))
                  (finalAttrs.finalPackage.overrideAttrs (attrs: {
                    src = makeSource {
                      system = builtins.head path;
                      phpMajor = builtins.head (builtins.tail (builtins.tail path));
                    };
                  }))
            )
            (lib.filterAttrsRecursive (name: _value: name != "platform") hashes)
          )
        );
  };

  meta = with lib; {
    description = "Next-generation Redis extension for PHP";
    changelog = "https://github.com/cachewerk/relay/releases/tag/v${version}";
    homepage = "https://relay.so/";
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ tillkruss ostrolucky ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
})
