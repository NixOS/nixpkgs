{ lib, buildDunePackage, cmdliner
, functoria-runtime
, rresult, astring, fmt, logs, bos, fpath, emile, uri
, alcotest
}:

buildDunePackage {
  pname   = "functoria";
  inherit (functoria-runtime) version src;

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [ cmdliner rresult astring fmt logs bos fpath emile uri ];

  # Tests are not compatible with cmdliner 1.3
  doCheck = false;
  checkInputs = [ alcotest functoria-runtime ];

  meta = with lib; {
    description = "A DSL to organize functor applications";
    homepage    = "https://github.com/mirage/functoria";
    license     = licenses.isc;
    maintainers = [ maintainers.vbgl ];
  };
}
