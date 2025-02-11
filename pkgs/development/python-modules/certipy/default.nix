{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  flask,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "certipy";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DA6nslJItC+5MPMBc6eMAp5rpn4u+VmMpEcNiXXJy7Y=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [
    flask
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "certipy" ];

  meta = with lib; {
    description = "Utility to create and sign CAs and certificates";
    homepage = "https://github.com/LLNL/certipy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ isgy ];
    mainProgram = "certipy";
  };
}
