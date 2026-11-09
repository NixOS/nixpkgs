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

buildPythonPackage (finalAttrs: {
  pname = "pynx584";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "pynx584";
    tag = finalAttrs.version;
    hash = "sha256-hTBi/muMmPrn7AVHQuuM3egADW+p18eFzU7l6bN/NkM=";
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
    changelog = "https://github.com/kk7ds/pynx584/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
