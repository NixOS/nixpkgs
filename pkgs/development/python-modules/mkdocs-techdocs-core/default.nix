{ lib
, buildPythonPackage
, fetchFromGitHub
, mkdocs
, pymdown-extensions
}:

buildPythonPackage rec {
  pname = "mkdocs-techdocs-core";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "backstage";
    repo = "mkdocs-techdocs-core";
    rev = "b91a812ea3ee72beaa349cd66674f487d79e2241";
    hash = "sha256-IvQaItBglOXdXXqpklLvlxav+xeAWMdelWffY3evAX8=";
  };

  propagatedBuildInputs = [
    mkdocs
    pymdown-extensions
  ];

  doCheck = false;

  meta = with lib; {
    description = "The core MkDocs plugin used by Backstage's TechDocs";
    homepage = "https://github.com/backstage/mkdocs-techdocs-core";
    license = licenses.asl20;
    maintainers = with maintainers; [ anthr76 ];
  };
}