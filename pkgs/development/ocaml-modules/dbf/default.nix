{ lib, buildDunePackage, fetchFromGitHub, ppx_cstruct, rresult, cstruct-unix
, core_kernel }:

buildDunePackage rec {
  pname = "dbf";
  version = "0.1.1";

  minimalOCamlVersion = "4.08";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "pveber";
    repo = "dbf";
    rev = version;
    hash = "sha256-h1K5YDLbXGEJi/quKXvSR0gZ+WkBzut7AsVFv+Bm8/g=";
  };

  buildInputs = [ ppx_cstruct ];
  propagatedBuildInputs = [ rresult cstruct-unix core_kernel ];

  meta = with lib; {
    description = "DBF format parsing";
    homepage = "https://github.com/pveber/dbf";
    license = licenses.isc;
    maintainers = [ maintainers.deltadelta ];
  };
}
