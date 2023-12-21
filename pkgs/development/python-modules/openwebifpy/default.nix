{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools

# dependencies
, aiohttp

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "openwebifpy";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4KYLjRD2n98t/MVan4ox19Yhz0xkSEMUKYdWqcwmBs4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Provides a python interface to interact with a device running OpenWebIf";
    downloadPage = "https://github.com/autinerd/openwebifpy";
    homepage = "https://openwebifpy.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}

