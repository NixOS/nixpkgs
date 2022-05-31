{ lib, buildDunePackage, alcotest, cmdliner
, rresult, astring, fmt, logs, bos, fpath, ptime, emile
, uri, functoria-runtime
}:

buildDunePackage {
  pname   = "functoria";
  inherit (functoria-runtime) version src;

  duneVersion = "3";

  minimumOCamlVersion = "4.08";


  propagatedBuildInputs = [ cmdliner rresult astring fmt logs bos fpath ptime uri emile ];
  checkInputs = [ alcotest functoria-runtime ];

  doCheck = true;

  meta = with lib; {
    description = "A DSL to organize functor applications";
    maintainers = [ maintainers.vbgl ];
    inherit (functoria-runtime.meta) homepage license;
  };
}
