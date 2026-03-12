{
  lib,
  buildPythonPackage,
  setuptools-scm,
  pythonOlder,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ppf-datamatrix";
  version = "0.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jwNNnJDkCPYPixCic7qrgQFMmoHJg9wevcMdTKWsVYI=";
  };

  doCheck = true;
  pythonImportsCheck = [ "ppf.datamatrix" ];
  nativeCheckInputs = [ pytestCheckHook ];

  build-system = [ setuptools-scm ];

  meta = {
    description = "Pure-python package to generate data matrix codes.";
    homepage = "https://github.com/adrianschlatter/ppf.datamatrix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kurogeek ];
  };
}
