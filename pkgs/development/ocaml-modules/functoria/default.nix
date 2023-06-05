{ lib, fetchurl, buildDunePackage, cmdliner
, rresult, astring, fmt, logs, bos, fpath, emile, uri
}:

buildDunePackage rec {
  pname   = "functoria";
  version = "4.3.6";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${version}/mirage-${version}.tbz";
    hash = "sha256-i/5sZHfxECoKYMdGje+U21GWxJ6dDZreVcQGtbuo4SE=";
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
