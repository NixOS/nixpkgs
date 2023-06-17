{ stdenv
, lib
, fetchurl
, php
, openssl
, openssl_1_1
, zstd
, lz4
, autoPatchelfHook
}:

let
  version = "0.6.3";
  system = stdenv.hostPlatform.system;
  phpVersion = lib.versions.majorMinor php.version;
  variation = {
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      hashes = {
        "8.0" = "00a7pyf9na7hjifkmp2482c7sh086w72zniqgr4cz2rhz7hnqp7p";
        "8.1" = "0mg6nsllycgjxxinn8s30y9sk06g40vk8blnpx0askjw5zdsf5y7";
        "8.2" = "0qmcbrj6jaxczv25rdgfjrj9nwq4vb2faw7kzlyxrvvzb5pyn9dm";
        "8.3" = "1hqjy5y4q3alxvrj7xksaf7vvmz8p51bgzxbvmzdx6jnl63dix33";
      };
    };
    "aarch64-linux" = {
      platform = "debian-aarch64+libssl3";
      hashes = {
        "8.0" = "19zzw4324z096b6bph1686r30i4i2kwmlmmcqmb33lqkr9b9n5ag";
        "8.1" = "0j6wpwy8d67pqij4v8m2xwydfddzr7nn4c3lyrssp8llbn4ghwpn";
        "8.2" = "1nbajvi5zk6z8qr32l86p65f1zxv12kald56pg8k7bj4axlj2pmy";
        "8.3" = "1sn638g2636m6s3lv2cclza9lzmzgqxamcga7jz3ijhn2ja6znbv";
      };
    };
    "x86_64-darwin" = {
      platform = "darwin-x86-64";
      hashes = {
        "8.0" = "13q6va9lxgfyx86xw20iqjz4s9r9xms74ywb2hgqrhs5mjnazzz4";
        "8.1" = "1ncih5bf0jcylpl0nj8hi50kcwb4nl1g0ql359dgg9gp8s1b4hmw";
        "8.2" = "150difm3vg0g2pl5hb5cci4jzybd7jcd7prjdv3rmwsi91gsydlv";
        # 8.3 for this platform does not exist
      };
    };
    "x86_64-linux" = {
      platform = "debian-x86-64+libssl3";
      hashes = {
        "8.0" = "1qvd5r591kp7qf9pkymz78s8llzs1vxjwqhwy9rvma21hh6gd8ld";
        "8.1" = "0fm9ppgx7qaggid134qnl9jkq5h97dac2ax21f1f1d0k8f5blmc2";
        "8.2" = "0g2yqwfrigf047dqkrvfcj318lvgp38zy522ry484mrgq7iqwvb8";
        "8.3" = "06mi3yr7k1a9icdljzl76xvrw6xqnvwiavgzx2g487s097mycjp4";
      };
    };
  }.${system} or (throw "Unsupported platform for relay: ${system}");
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "relay";
  extensionName = "relay";

  src = fetchurl {
    url = "https://builds.r2.relay.so/v${finalAttrs.version}/relay-v${finalAttrs.version}-php"
      + phpVersion + "-" + variation.platform + ".tar.gz";
    sha256 = variation.hashes.${phpVersion} or (throw "Unsupported PHP version for relay ${phpVersion} on ${system}");
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
        (v: " -change /Users/administrator/dev/relay-dev/relay-deps/build/arm64/lib/${v.name}"
          + " ${lib.strings.makeLibraryPath [ v.value ]}/${v.name}")
        (with lib.attrsets; [
          (nameValuePair "libssl.1.1.dylib" openssl_1_1)
          (nameValuePair "libcrypto.1.1.dylib" openssl_1_1)
          (nameValuePair "libzstd.1.dylib" zstd)
          (nameValuePair "liblz4.1.dylib" lz4)
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
