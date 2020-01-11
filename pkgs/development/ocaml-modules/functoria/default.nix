{ stdenv, fetchurl, buildDunePackage, alcotest, cmdliner
, rresult, astring, fmt, ocamlgraph, logs, bos, fpath, ptime
}:

buildDunePackage rec {
  pname   = "functoria";
  version = "3.0.3";

  minimumOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "08wv2890gz7ci1fa2b3z4cvqf98nqb09f89y08kcmnsirlbbzlfh";
  };

  propagatedBuildInputs = [ cmdliner rresult astring fmt ocamlgraph logs bos fpath ptime ];
  checkInputs = [ alcotest ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A DSL to organize functor applications";
    homepage    = https://github.com/mirage/functoria;
    license     = licenses.isc;
    maintainers = [ maintainers.vbgl ];
  };
}
