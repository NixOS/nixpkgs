{ lib, buildDunePackage, fetchFromGitLab, yojson }:

buildDunePackage rec {
  pname = "ocf";
  version = "0.8.0";
  duneVersion = "3";
  minimalOCamlVersion = "4.03";
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "ocf";
    rev = version;
    sha256 = "sha256:00ap3q5yjqmpk87lxqv1j2wkc7583ynhjr1jjrfn9r0j2h9pfd60";
  };

  propagatedBuildInputs = [ yojson ];

  meta = with lib; {
    description = "OCaml library to read and write configuration options in JSON syntax";
    homepage = "https://zoggy.frama.io/ocf/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ regnat ];
  };
}
