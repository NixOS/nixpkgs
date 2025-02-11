{
  lib,
  buildDunePackage,
  fetchurl,
  cmdliner,
}:

buildDunePackage rec {
  pname = "functoria-runtime";
  version = "4.4.1";

  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${version}/mirage-${version}.tbz";
    hash = "sha256-FKCdzrRJVpUrCWqrTiE8l00ZKJOYsvI9mNzJ0ZxDBwg=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [ cmdliner ];

  meta = with lib; {
    homepage = "https://github.com/mirage/functoria";
    license = licenses.isc;
    description = "Runtime support library for functoria-generated code";
    maintainers = [ maintainers.sternenseemann ];
  };
}
