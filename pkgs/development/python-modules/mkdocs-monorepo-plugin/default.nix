{ lib
, buildPythonPackage
, fetchFromGitHub
, mkdocs
, pymdown-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mkdocs-monorepo-plugin";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "backstage";
    repo = "mkdocs-monorepo-plugin";
    rev = "c778b3010eb986a2f3b719bc7a3d29d86236c238";
    hash = "sha256-IvQaItBglOXdXXqpklLvlxav+xeAWMdelWffY3evAX8=";
  };

  propagatedBuildInputs = [
    mkdocs
    pymdown-extensions
  ];

  doCheck = false;

  meta = with lib; {
    description = "Build multiple documentation folders in a single Mkdocs";
    homepage = "https://github.com/backstage/mkdocs-monorepo-plugin";
    license = licenses.asl20;
    maintainers = with maintainers; [ anthr76 ];
  };
}