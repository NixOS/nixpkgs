{ lib, buildDunePackage, fetchFromGitLab, sedlex, xtmpl }:

buildDunePackage rec {
  pname = "higlo";
  version = "0.8";
  duneVersion = "3";
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "higlo";
    rev = version;
    sha256 = "sha256:09hsbwy5asacgh4gdj0vjpy4kzfnq3qji9szbsbyswsf1nbyczir";
  };

  propagatedBuildInputs = [ sedlex xtmpl ];

  meta = with lib; {
    description = "OCaml library for syntax highlighting";
    inherit (src.meta) homepage;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ regnat ];
  };
}


