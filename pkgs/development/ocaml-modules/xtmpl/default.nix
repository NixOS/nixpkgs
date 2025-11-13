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
  version = "1.2.0";
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "xtmpl";
    tag = version;
    hash = "sha256-ShKUncmdh3U0zU9AymvO6Vz0c2XalPpgjHamriu0+hI=";
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
