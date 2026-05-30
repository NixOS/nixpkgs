{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  mock,
  prettytable,
  pyserial,
  pytestCheckHook,
  requests,
  stevedore,
}:

buildPythonPackage {
  pname = "pynx584";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "pynx584";
    tag = "0.8.2";
    hash = "sha256-q5ra7tH4kaBrw0VAiyMsmWOkVhA7Y6bRuFP8dlxQjsE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    prettytable
    pyserial
    requests
    stevedore
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nx584" ];

  meta = {
    description = "Python package for communicating to NX584/NX8E interfaces";
    homepage = "https://github.com/kk7ds/pynx584";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
