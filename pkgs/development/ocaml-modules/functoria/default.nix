{ lib, fetchurl, buildDunePackage, cmdliner
, rresult, astring, fmt, logs, bos, fpath, emile, uri
}:

buildDunePackage rec {
  pname   = "functoria";
  version = "4.2.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${version}/mirage-${version}.tbz";
    sha256 = "sha256-rZ9y8+wbDjqjY1sx+TmSoR42hUKRMGpehCCR2cEgbv8=";
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
