{ stdenv, fetchgit, chez, chez-srfi, chez-mit }:

stdenv.mkDerivation {
  pname = "chez-scmutils";
  version = "1.0";

  src = fetchgit {
    url = "https://github.com/fedeinthemix/chez-scmutils.git";
    rev = "5eaeea6289fd239358d7eed99cc9588528fb52b2";
    sha256 = "0lb05wlf8qpgg8y0gdsyaxg1nbfx1qbaqdjvygrp64ndn8fnhq7l";
  };

  buildInputs = [ chez chez-srfi chez-mit ];

  buildPhase = ''
    make PREFIX=$out CHEZ=${chez}/bin/scheme
  '';

  installPhase = ''
    make install PREFIX=$out CHEZ=${chez}/bin/scheme
  '';

  doCheck = false;

  meta = {
    description = "This is a port of the ‘MIT Scmutils’ library to Chez Scheme";
    homepage = "https://github.com/fedeinthemix/chez-scmutils/";
    maintainers = [ stdenv.lib.maintainers.jitwit ];
    license = stdenv.lib.licenses.gpl3;
  };

}
