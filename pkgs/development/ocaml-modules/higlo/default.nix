{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  sedlex,
  xtmpl,
}:

buildDunePackage rec {
  pname = "higlo";
  version = "0.10.0";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "higlo";
    rev = version;
    hash = "sha256-A5Su4+eBOq/WNdY/3EBQ3KqrRQuaCI1x25cEuoZp4Mo=";
  };

  propagatedBuildInputs = [
    sedlex
    xtmpl
  ];

  meta = with lib; {
    description = "OCaml library for syntax highlighting";
    inherit (src.meta) homepage;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ regnat ];
  };
}
