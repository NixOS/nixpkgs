{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "7.4.4";
  pyproject = true;

  # uses f strings
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yQHfg9CXZJ4lfoA74iWSrt/VGC8Hs8yH1kC7ua/VD0k=";
  };

  nativeBuildInputs = [ setuptools ];

  # No tests in archive
  doCheck = false;
  nativeCheckInputs = [ mock ];

  meta = {
    description = "Code coverage measurement for python";
    homepage = "https://coverage.readthedocs.io/";
    license = lib.licenses.bsd3;
  };
}
