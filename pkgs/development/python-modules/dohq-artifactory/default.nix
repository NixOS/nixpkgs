{
  lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, setuptools
, requests
, python-dateutil
, pyjwt
, pytestCheckHook
, responses
, nix-update-script
}:

buildPythonPackage rec {
  pname = "dohq-artifactory";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "devopshq";
    repo = "artifactory";
    rev = version;
    hash = "sha256-gccVwshGBgbhTSX4o0vANIRct1isqDj+gWeZZxExj9Q=";
  };

  # https://github.com/devopshq/artifactory/issues/430
  disabled = pythonAtLeast "3.12";

  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [
    requests
    python-dateutil
    pyjwt
  ];

  pythonImportsCheck = [ "artifactory" ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pytestFlagsArray = [ "tests/unit" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Python interface library for JFrog Artifactory";
    homepage = "https://devopshq.github.io/artifactory/";
    changelog = "https://github.com/devopshq/artifactory/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ h7x4 ];
  };
}
