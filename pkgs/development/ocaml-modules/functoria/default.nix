{ lib, fetchurl, buildDunePackage, alcotest, cmdliner
, rresult, astring, fmt, ocamlgraph, logs, bos, fpath, ptime
}:

buildDunePackage rec {
  pname   = "functoria";
  version = "3.1.1";

  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "0bihxbq16zwsi7frk4b8wz8993mvy2ym3n6288jhv0n0gb7c2f7m";
  };

  propagatedBuildInputs = [ cmdliner rresult astring fmt ocamlgraph logs bos fpath ptime ];
  checkInputs = [ alcotest ];

  doCheck = true;

  meta = with lib; {
    description = "A DSL to organize functor applications";
    homepage    = "https://github.com/mirage/functoria";
    license     = licenses.isc;
    maintainers = [ maintainers.vbgl ];
  };
}
