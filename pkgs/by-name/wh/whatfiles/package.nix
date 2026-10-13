{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "whatfiles";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "spieglt";
    repo = "whatfiles";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MtYoKY33HjjxN+z4w5pKJ4n0v4xVygR/aLTd+qygODo=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/whatfiles $out/bin/whatfiles

    runHook postInstall
  '';

  meta = {
    description = "Log what files are accessed by any Linux process";
    homepage = "https://github.com/spieglt/whatfiles";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "whatfiles";
  };
})
