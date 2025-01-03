{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppx_cstruct,
  rresult,
  cstruct-unix,
  core_kernel,
}:

buildDunePackage rec {
  pname = "dbf";
  version = "0.2.0";

  minimalOCamlVersion = "4.08";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "pveber";
    repo = "dbf";
    rev = "v${version}";
    hash = "sha256-096GodM3J/4dsVdylG+6xz/p6ogUkhDGdFjiPwl/jLQ=";
  };

  buildInputs = [ ppx_cstruct ];
  propagatedBuildInputs = [
    rresult
    cstruct-unix
    core_kernel
  ];

  meta = with lib; {
    description = "DBF format parsing";
    homepage = "https://github.com/pveber/dbf";
    license = licenses.isc;
    maintainers = [ maintainers.deltadelta ];
  };
}
