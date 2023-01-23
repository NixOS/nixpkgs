{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, hatchling
}:

buildPythonPackage rec {
  pname = "hatch-nodejs-version";
  version = "0.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agoose77";
    repo = "hatch-nodejs-version";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-txF392XiRqHndTEYw6QVk12Oqw9E6cOwF81hUyp2oh4=";
  };

  propagatedBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
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
