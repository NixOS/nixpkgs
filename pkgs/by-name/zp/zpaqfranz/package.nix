{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zpaqfranz";
  version = "60.9";

  src = fetchFromGitHub {
    owner = "fcorbelli";
    repo = "zpaqfranz";
    rev = finalAttrs.version;
    hash = "sha256-7X1nmJ6X1oRMzB3L/oKe3ARY02ZimUD09KO4fukxTyg=";
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
    changelog = "https://github.com/fcorbelli/zpaqfranz/releases/tag/${finalAttrs.version}";
    description = "Advanced multiversioned deduplicating archiver, with HW acceleration, encryption and paranoid-level tests";
    mainProgram = "zpaqfranz";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
