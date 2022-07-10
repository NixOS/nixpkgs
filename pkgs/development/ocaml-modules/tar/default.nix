{ lib
, fetchFromGitHub
, buildDunePackage
, camlp-streams
, ppx_cstruct
, cstruct
, re
, ppx_tools
}:

buildDunePackage rec {
  pname = "tar";
  version = "2.0.1";
  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-tar";
    rev = "v${version}";
    sha256 = "1zr1ak164k1jm15xwqjf1iv77kdrrahak33wrxg7lifz9nnl0dms";
  };

  useDune2 = true;

  propagatedBuildInputs = [
    camlp-streams
    ppx_cstruct
    cstruct
    re
  ];

  buildInputs = [
    ppx_tools
  ];

  doCheck = true;

  meta = {
    description = "Decode and encode tar format files from Unix";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
