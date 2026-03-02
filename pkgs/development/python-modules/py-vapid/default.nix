{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  mock,
  pytestCheckHook,
  cryptography,
}:

buildPythonPackage rec {
  pname = "py-vapid";
  version = "1.9.4";
  pyproject = true;

  src = fetchPypi {
    pname = "py_vapid";
    inherit version;
    hash = "sha256-oAQCNWDLxU40/AY4CgWA8E/8x4joT7bRnpM57rZVGig=";
  };

  build-system = [ hatchling ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  meta = {
    description = "Library for VAPID header generation";
    mainProgram = "vapid";
    homepage = "https://github.com/mozilla-services/vapid";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}
