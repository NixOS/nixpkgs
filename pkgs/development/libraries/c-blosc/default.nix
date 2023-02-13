{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "c-blosc";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc";
    rev = "v${version}";
    sha256 = "sha256-6SKEyciwDOxcbO8chvmxrLCxLkc93zxo6eH0c/lRyT8=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A blocking, shuffling and loss-less compression library";
    homepage = "https://www.blosc.org";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
