{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, typing-extensions
}:

buildPythonPackage rec {
  pname = "http-sf";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mnot";
    repo = "http-sf";
    rev = "refs/tags/v${version}";
    hash = "sha256-8xK8/IVrhqMDgkxZY10QqSGswCrttc29FZLCntmSUQ4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  # Tests require external data (https://github.com/httpwg/structured-field-tests)
  doCheck = false;

  pythonImportsCheck = [
    "http_sf"
  ];

  meta = with lib; {
    description = "Module to parse and serialise HTTP structured field values";
    homepage = "https://github.com/mnot/http-sf";
    changelog = "https://github.com/mnot/http-sf/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
