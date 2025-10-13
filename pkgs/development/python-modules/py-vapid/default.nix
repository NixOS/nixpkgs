{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  mock,
  pytestCheckHook,
  cryptography,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "py-vapid";
  version = "1.9.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "py_vapid";
    inherit version;
    hash = "sha256-PIlzts+DhK0MmuZNYnDMxIDguSxwLY9eoswD5rUSR/k=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Library for VAPID header generation";
    mainProgram = "vapid";
    homepage = "https://github.com/mozilla-services/vapid";
    license = licenses.mpl20;
    maintainers = [ ];
  };
}
