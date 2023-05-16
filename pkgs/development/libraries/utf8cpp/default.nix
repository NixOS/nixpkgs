{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "utf8cpp";
<<<<<<< HEAD
  version = "3.2.4";
=======
  version = "3.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nemtrif";
    repo = "utfcpp";
    rev = "v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    sha256 = "sha256-cpy1lg/9pWgI5uyOO9lfSt8llfGEjnu/O4P9688XVEA=";
=======
    sha256 = "sha256-PnHbbjsryRwMMu517ta18qNgwOM6hRnVmXmR3fzS1+4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  nativeBuildInputs = [ cmake ];

  # Tests fail on darwin, probably due to a bug in the test framework:
  # https://github.com/nemtrif/utfcpp/issues/84
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://github.com/nemtrif/utfcpp";
    description = "UTF-8 with C++ in a Portable Way";
    license = licenses.boost;
    maintainers = with maintainers; [ jobojeha ];
    platforms = platforms.all;
  };
}
