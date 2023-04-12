{ stdenv, lib, fetchFromGitHub, chez }:

stdenv.mkDerivation {
  pname = "chez-srfi";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "fedeinthemix";
    repo = "chez-srfi";
    rev = "5770486c2a85d0e3dd4ac62a97918e7c394ea507";
    sha256 = "sha256-8icdkbYmpTpossirFoulUhJY/8Jo+2eeaMwDftbZh+g=";
  };

  buildInputs = [ chez ];

  buildPhase = ''
    make PREFIX=$out CHEZ=${chez}/bin/scheme
  '';

  installPhase = ''
    make install PREFIX=$out CHEZ=${chez}/bin/scheme
  '';

  doCheck = false;

  meta = with lib; {
    description = "This package provides a collection of SRFI libraries for Chez Scheme";
    homepage = "https://github.com/fedeinthemix/chez-srfi/";
    maintainers = [ maintainers.jitwit ];
    license = licenses.free;
  };

}
