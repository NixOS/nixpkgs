{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "libdivsufsort";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "y-256";
    repo = pname;
    rev = "${version}";
    hash = "sha256-4p+L1bq9SBgWSHXx+WYWAe60V2g1AN+zlJvC+F367Tk=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/y-256/libdivsufsort";
    license = lib.licenses.mit;
    description = "Library to construct the suffix array and the BW transformed string";
    platforms = lib.platforms.unix;
  };
}
