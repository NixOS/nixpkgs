{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  six,
  testtools,
}:

buildPythonPackage rec {
  pname = "effect";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Pure effects for Python";
    homepage = "https://effect.readthedocs.io/";
    changelog = "https://github.com/python-effect/effect/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
