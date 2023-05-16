{ lib, mkDerivation, fetchFromGitHub, ghc }:

mkDerivation rec {
  pname = "cubical";
<<<<<<< HEAD
  version = "0.5";
=======
  version = "unstable-2023-02-09";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    repo = pname;
    owner = "agda";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-47GOfZYwvE9TbGzdy/xSYZagTbjs/oeDpwjYUvI7z3k=";
=======
    rev = "6b1ce0b67fd94693c1a3e340c8e8765380de0edc";
    hash = "sha256-XRCaW94oAgy2GOnFiI9c5A8mEx7AzlbT4pFd+PMmc9o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # The cubical library has several `Everything.agda` files, which are
  # compiled through the make file they provide.
  nativeBuildInputs = [ ghc ];
  buildPhase = ''
    runHook preBuild
    make
    runHook postBuild
  '';

  meta = with lib; {
    description =
      "A cubical type theory library for use with the Agda compiler";
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ alexarice ryanorendorff ncfavier ];
  };
}
