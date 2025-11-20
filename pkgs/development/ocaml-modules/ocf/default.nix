{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  yojson,
}:

buildDunePackage rec {
  pname = "ocf";
  version = "1.0.0";
  duneVersion = "3";
  minimalOCamlVersion = "4.03";
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "ocf";
    rev = version;
    sha256 = "sha256-lvWQ33tOk9dXeZcM2UDsszN+EchS9fFqK5FmuMc1xck=";
  };

  propagatedBuildInputs = [ yojson ];

  meta = with lib; {
    description = "OCaml library to read and write configuration options in JSON syntax";
    homepage = "https://zoggy.frama.io/ocf/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ regnat ];
  };
}
