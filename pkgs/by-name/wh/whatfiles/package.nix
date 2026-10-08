{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "whatfiles";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "spieglt";
    repo = "whatfiles";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5Ju9g7/B9uxLkQzV/MN3vBkjve4EAMseO6K4HTAoS/o=";
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
