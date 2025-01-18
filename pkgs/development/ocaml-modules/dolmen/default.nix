{
  lib,
  fetchurl,
  buildDunePackage,
  menhir,
  menhirLib,
  fmt,
  hmap,
  qcheck,
}:

buildDunePackage rec {
  pname = "dolmen";
  version = "0.10";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/Gbury/dolmen/releases/download/v${version}/dolmen-${version}.tbz";
    hash = "sha256-xchfd+OSTzeOjYLxZu7+QTG04EG/nN7KRnQQ8zxx+mE=";
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [
    menhirLib
    fmt
    hmap
  ];

  doCheck = true;

  checkInputs = [ qcheck ];

  meta = with lib; {
    description = "OCaml library providing clean and flexible parsers for input languages";
    license = licenses.bsd2;
    maintainers = [ maintainers.vbgl ];
    homepage = "https://github.com/Gbury/dolmen";
  };
}
