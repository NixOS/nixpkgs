{ 
  lib,
  stdenv, 
  fetchurl, 
  gmp, 
  flex, 
  bison 
}:

stdenv.mkDerivation rec {
  pname = "pbc";
  version = "1.0.0";

  src = fetchurl {
    url = "https://crypto.stanford.edu/pbc/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-GCdaNnKDB3uv419EMgBJnjsZxKN1SVPaKhsvDWtZItw=";
  };

  buildInputs = [ 
    gmp
  ];
  nativeBuildInputs = [ 
    bison 
    flex 
  ];

  strictDeps = true;

  LEX = "flex";
  LEXLIB = "-lfl";
  ac_cv_lib_fl_yywrap = "yes";

  meta = with lib; {
    description = "Pairing-based cryptography library by Stanford";
    homepage = "https://crypto.stanford.edu/pbc/";
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ tphanir ];
  };
}
