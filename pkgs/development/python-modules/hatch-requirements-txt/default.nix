{ lib
, buildPythonPackage
, fetchFromGitHub
, hatch
, hatchling
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "hatch-requirements-txt";
  version = "0.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "repo-helper";
    repo = "hatch-requirements-txt";
    rev = "refs/tags/v${version}";
    hash = "sha256-Gyt5Fs8uqVe0cOKtxFeg1n1WMyeK5Iokh71ynb2i5cM=";
  };

  nativeBuildInputs = [
    hatch
  ];

  propagatedBuildInputs = [
    hatchling
    packaging
  ];

  doCheck = false; # missing coincidence dependency

  checkInputs = [
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

