{ stdenv, fetchurl, buildDunePackage, alcotest, cmdliner
, rresult, astring, fmt, ocamlgraph, logs, bos, fpath, ptime
}:

buildDunePackage rec {
  pname   = "functoria";
  version = "3.1.0";

  minimumOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "15jdqdj1vfi0x9gjydrrnbwzwbzw34w1iir032jrji820xlblky2";
  };

  propagatedBuildInputs = [ cmdliner rresult astring fmt ocamlgraph logs bos fpath ptime ];
  checkInputs = [ alcotest ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A DSL to organize functor applications";
    homepage    = "https://github.com/mirage/functoria";
    license     = licenses.isc;
    maintainers = [ maintainers.vbgl ];
  };
}
