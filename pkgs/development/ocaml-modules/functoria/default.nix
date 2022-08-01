{ lib, fetchurl, buildDunePackage, alcotest, cmdliner_1_1
, rresult, astring, fmt, ocamlgraph, logs, bos, fpath, ptime
}:

buildDunePackage rec {
  pname   = "functoria";
  version = "3.1.2";

  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "1yh0gkf6f2g960mcnrpilhj3xrszr98hy4zkav078f6amxcmwyl4";
  };

  propagatedBuildInputs = [ cmdliner_1_1 rresult astring fmt ocamlgraph logs bos fpath ptime ];
  checkInputs = [ alcotest ];

  doCheck = true;

  meta = with lib; {
    description = "A DSL to organize functor applications";
    homepage    = "https://github.com/mirage/functoria";
    license     = licenses.isc;
    maintainers = [ maintainers.vbgl ];
  };
}
