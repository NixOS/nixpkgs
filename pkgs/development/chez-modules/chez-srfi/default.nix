{ stdenv, lib, fetchgit, chez }:

stdenv.mkDerivation {
  pname = "chez-srfi";
  version = "1.0";

  src = fetchgit {
    url = "https://github.com/fedeinthemix/chez-srfi.git";
    rev = "5770486c2a85d0e3dd4ac62a97918e7c394ea507";
    sha256 = "1s47v7b7w0ycd2g6gyv8qbzmh4jjln5iday8n9l3m996ns8is9zj";
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
