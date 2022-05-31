{ lib, fetchurl, buildDunePackage, cmdliner, fmt, alcotest }:

buildDunePackage rec {
  pname = "functoria-runtime";
  version = "4.1.1";

  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${version}/mirage-${version}.tbz";
    sha256 = "sha256-Os5Mj9MybpWg8rfrerB7HZ82433hsAZsrifTa0/FhxU=";
  };

  propagatedBuildInputs = [ cmdliner fmt ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = with lib; {
    description = "Runtime support library for functoria-generated code";
    homepage    = "https://github.com/mirage/mirage";
    license     = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
