{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zpaqfranz";
  version = "59.7";

  src = fetchFromGitHub {
    owner = "fcorbelli";
    repo = "zpaqfranz";
    rev = finalAttrs.version;
    hash = "sha256-BP9aAzS5ZeT0mZeheQY7tcnTLuJZMWz3se1phv5u5BI=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildPhase = ''
    runHook preBuild

    eval $CXX $CXXFLAGS $CPPFLAGS $LDFLAGS -Dunix zpaqfranz.cpp -o zpaqfranz -pthread

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 zpaqfranz -t $out/bin/
    installManPage man/zpaqfranz.1

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/fcorbelli/zpaqfranz";
    description = "Advanced multiversioned deduplicating archiver, with HW acceleration, encryption and paranoid-level tests";
    mainProgram = "zpaqfranz";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
