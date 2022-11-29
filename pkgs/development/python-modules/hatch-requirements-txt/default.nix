{ lib
, fetchFromGitHub
, buildPythonPackage
, hatchling
}:

let
  pname = "hatch-requirements-txt";
  version = "0.2.0";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "repo-helper";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-YaLWWSZDAdCj3zoAJ6Fc2meH8l6bKd/+1NNlliKgzFo=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  pythonImportsCheck = [ "hatch_requirements_txt" ];

  meta = with lib; {
    description = "Hatchling plugin to read project dependencies from requirements.txt";
    homepage = "https://github.com/repo-helper/hatch-requirements-txt";
    license = licenses.mit;
    maintainers = with maintainers; [ snpschaaf ];
  };
}
