{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  scipy,
  sympy,
  setuptools,
  pytestCheckHook,
  cython,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pydy";
  version = "0.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G3iqMzy/W3ctz/c4T3LqYyTTMVbly1GMkmMLi96mzMc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    sympy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    cython
  ];

  pythonImportsCheck = [ "pydy" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python tool kit for multi-body dynamics";
    homepage = "http://pydy.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
