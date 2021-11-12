{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "c-blosc";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc";
    rev = "v${version}";
    sha256 = "sha256-B8SFOc1oGgU5AGAbkqe5oz045H08TnymNAbzz2oOKoo=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A blocking, shuffling and loss-less compression library";
    homepage = "https://www.blosc.org";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
