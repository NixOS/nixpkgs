{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hatch-requirements-txt";
  version = "0.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "repo-helper";
    repo = "hatch-requirements-txt";
    rev = "refs/tags/v${version}";
    hash = "sha256-qk+70o/41BLxCuz3SOXkGYSEmUZOG1oLYcFUmlarqmY=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    hatchling
    packaging
  ];

  doCheck = false; # missing coincidence dependency

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/repo-helper/hatch-requirements-txt/releases/tag/${version}";
    description = "Hatchling plugin to read project dependencies from requirements.txt";
    homepage = "https://github.com/repo-helper/hatch-requirements-txt";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

