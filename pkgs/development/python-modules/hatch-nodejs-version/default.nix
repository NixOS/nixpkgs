{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, hatchling
}:

buildPythonPackage rec {
  pname = "hatch-nodejs-version";
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agoose77";
    repo = "hatch-nodejs-version";
    rev = "v${version}";
    sha256 = "sha256-TBvqXjka8poQ8xxQ/H1hFYRLqnP1024uan1d9b95ags=";
  };

  propagatedBuildInputs = [
    hatchling
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hatch_nodejs_version"
  ];

  meta = with lib; {
    description = "Plugins for dealing with NodeJS versions";
    homepage = "https://github.com/agoose77/hatch-nodejs-version";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
