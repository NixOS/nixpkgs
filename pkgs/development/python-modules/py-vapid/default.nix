{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pytestCheckHook,
  cryptography,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "py-vapid";
  version = "1.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "py_vapid";
    inherit version;
    hash = "sha256-/itUYb9Fx7r/EDnfaYHwO4f6qHzeBIKt36NbP+Y2rBs=";
  };

  propagatedBuildInputs = [ cryptography ];

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
