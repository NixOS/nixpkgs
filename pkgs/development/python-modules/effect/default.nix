{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  six,
  testtools,
}:

buildPythonPackage rec {
  pname = "effect";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ev+2A3B8ZIsHsReB67eTpLmu6KzxrFdkw+0hEq3wyeo=";
  };

  postPatch = ''
    substituteInPlace effect/test_do.py \
      --replace "py.test" "pytest"
  '';

  propagatedBuildInputs = [
    attrs
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ testtools ];

  pythonImportsCheck = [ "effect" ];

  meta = {
    description = "Pure effects for Python";
    homepage = "https://effect.readthedocs.io/";
    changelog = "https://github.com/python-effect/effect/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
