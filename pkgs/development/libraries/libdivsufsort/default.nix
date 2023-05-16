<<<<<<< HEAD
{lib, stdenv, fetchFromGitHub, cmake}:
=======
{lib, stdenv, fetchurl}:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "libdivsufsort";
  version = "2.0.1";

<<<<<<< HEAD
  src = fetchFromGitHub {
    owner = "y-256";
    repo = pname;
    rev = "${version}";
    hash = "sha256-4p+L1bq9SBgWSHXx+WYWAe60V2g1AN+zlJvC+F367Tk=";
  };

  nativeBuildInputs = [ cmake ];

=======
  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libdivsufsort/libdivsufsort-${version}.tar.bz2";
    sha256 = "1g0q40vb2k689bpasa914yi8sjsmih04017mw20zaqqpxa32rh2m";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = {
    homepage = "https://github.com/y-256/libdivsufsort";
    license = lib.licenses.mit;
    description = "Library to construct the suffix array and the BW transformed string";
    platforms = lib.platforms.unix;
  };
}
