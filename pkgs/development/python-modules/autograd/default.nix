{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  numpy,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "autograd";
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3nQ/02jW31I803MF3NFxhhqXUqFESTZ30sn1pWmD/y8=";
  };

  build-system = [ hatchling ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "autograd" ];

  meta = with lib; {
    description = "Compute derivatives of NumPy code efficiently";
    homepage = "https://github.com/HIPS/autograd";
    changelog = "https://github.com/HIPS/autograd/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
