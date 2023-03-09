{ lib, fetchurl, buildDunePackage, cmdliner
, rresult, astring, fmt, logs, bos, fpath, emile, uri
}:

buildDunePackage rec {
  pname   = "functoria";
  version = "4.3.4";

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${version}/mirage-${version}.tbz";
    hash = "sha256-ZN8La2+N19wVo/vBUfIj17JU6FSp0jX7h2nDoIpR1XY=";
  };

  propagatedBuildInputs = [ cmdliner rresult astring fmt logs bos fpath emile uri ];

  doCheck = false;

  meta = with lib; {
    description = "A DSL to organize functor applications";
    homepage    = "https://github.com/mirage/functoria";
    license     = licenses.isc;
    maintainers = [ maintainers.vbgl ];
  };
}
