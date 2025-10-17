{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  iri,
  logs,
  re,
  sedlex,
  uutf,
}:

buildDunePackage rec {
  pname = "xtmpl";
  version = "1.1.0";
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "xtmpl";
    tag = version;
    hash = "sha256-CgVbSjHuRp+5IZdfkxGzaBP8p7pQdXu6S/MMgiPMw3E=";
  };

  propagatedBuildInputs = [
    iri
    logs
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
