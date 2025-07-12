{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  iri,
  re,
  sedlex,
  uutf,
}:

buildDunePackage rec {
  pname = "xtmpl";
  version = "0.19.0";
  duneVersion = "3";
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "xtmpl";
    rev = version;
    sha256 = "sha256:0vwj0aayg60wm98d91fg3hmj90730liljy4cn8771dpxvz8m07bw";
  };

  propagatedBuildInputs = [
    iri
    re
    sedlex
    uutf
  ];

  meta = with lib; {
    description = "XML templating library for OCaml";
    homepage = "https://www.good-eris.net/xtmpl/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ regnat ];
  };
}
