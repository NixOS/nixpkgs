{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "whatfiles";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "spieglt";
    repo = "whatfiles";
    rev = "v${version}";
    hash = "sha256-5Ju9g7/B9uxLkQzV/MN3vBkjve4EAMseO6K4HTAoS/o=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/whatfiles $out/bin/whatfiles

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Log what files are accessed by any Linux process";
    homepage = "https://github.com/spieglt/whatfiles";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Log what files are accessed by any Linux process";
    homepage = "https://github.com/spieglt/whatfiles";
    license = licenses.gpl3Only;
    maintainers = [ ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "whatfiles";
  };
}
