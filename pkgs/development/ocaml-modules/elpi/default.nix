{ lib, fetchzip, buildDunePackage, camlp5
, ppxlib, ppx_deriving, re, perl, ncurses
}:

buildDunePackage rec {
  pname = "elpi";
  version = "1.11.4";

   src = fetchzip {
     url = "https://github.com/LPCIC/elpi/releases/download/v${version}/elpi-v${version}.tbz";
     sha256 = "1hmjp2z52j17vwhhdkj45n9jx11jxkdg2dwa0n04yyw0qqy4m7c1";
   };

  minimumOCamlVersion = "4.04";

  buildInputs = [ perl ncurses ppxlib ];

  propagatedBuildInputs = [ camlp5 ppx_deriving re ];

  meta = {
    description = "Embeddable λProlog Interpreter";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/LPCIC/elpi";
  };

  postPatch = ''
    substituteInPlace elpi_REPL.ml --replace "tput cols" "${ncurses}/bin/tput cols"
  '';

  useDune2 = true;
}
