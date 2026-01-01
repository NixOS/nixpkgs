{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "unshield";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "twogood";
    repo = "unshield";
    rev = version;
    sha256 = "sha256-CYlrPwNPneJIwvQCnzyfi6MZiXoflMDfUDCRL79+yBk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    zlib
    openssl
  ];

<<<<<<< HEAD
  meta = {
    description = "Tool and library to extract CAB files from InstallShield installers";
    homepage = "https://github.com/twogood/unshield";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
=======
  meta = with lib; {
    description = "Tool and library to extract CAB files from InstallShield installers";
    homepage = "https://github.com/twogood/unshield";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "unshield";
  };
}
