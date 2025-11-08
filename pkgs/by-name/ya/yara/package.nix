{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  protobufc,
  withCrypto ? true,
  openssl,
  enableCuckoo ? true,
  jansson,
  enableDex ? true,
  enableDotNet ? true,
  enableMacho ? true,
  enableMagic ? true,
  file,
  enableStatic ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yara";
  version = "4.5.4";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vSwjP0wbC65jEOxY9zrHAV1gEhcZ96emqvkuUw20Twc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    protobufc
  ]
  ++ lib.optionals withCrypto [ openssl ]
  ++ lib.optionals enableMagic [ file ]
  ++ lib.optionals enableCuckoo [ jansson ];

  preConfigure = "./bootstrap.sh";

  configureFlags = [
    (lib.withFeature withCrypto "crypto")
    (lib.enableFeature enableCuckoo "cuckoo")
    (lib.enableFeature enableDex "dex")
    (lib.enableFeature enableDotNet "dotnet")
    (lib.enableFeature enableMacho "macho")
    (lib.enableFeature enableMagic "magic")
    (lib.enableFeature enableStatic "static")
  ];

  doCheck = enableStatic;

  # bin/yara contain forbidden references to /build/.
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" $out/bin/yara
  '';

  meta = {
    description = "Tool to perform pattern matching for malware-related tasks";
    homepage = "http://Virustotal.github.io/yara/";
    changelog = "https://github.com/VirusTotal/yara/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "yara";
    platforms = lib.platforms.all;
  };
})
