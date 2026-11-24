{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zpaqfranz";
  version = "65.22";

  src = fetchFromGitHub {
    owner = "fcorbelli";
    repo = "zpaqfranz";
    tag = finalAttrs.version;
    hash = "sha256-pzBmTxzAadazgPN3KihWYxpybc1Pl3JdGrVX7Iqrjb0=";
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
    platforms = lib.platforms.unix;
  };
})
