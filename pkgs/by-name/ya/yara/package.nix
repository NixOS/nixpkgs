{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pcre,
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

stdenv.mkDerivation rec {
  pname = "yara";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara";
    tag = "v${version}";
    hash = "sha256-ryRbLXnhC7nAxtlhr4bARxmNdtPhpvGKwlOiYPYPXOE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs =
    [
      pcre
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

  meta = with lib; {
    description = "Tool to perform pattern matching for malware-related tasks";
    homepage = "http://Virustotal.github.io/yara/";
    changelog = "https://github.com/VirusTotal/yara/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "yara";
    platforms = platforms.all;
  };
}
