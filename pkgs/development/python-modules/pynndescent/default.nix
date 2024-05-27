{
  lib,
  buildPythonPackage,
  fetchPypi,
  importlib-metadata,
  joblib,
  llvmlite,
  numba,
  scikit-learn,
  scipy,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pynndescent";
  version = "0.5.12";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BzYpH8u+39Xgo6KA9xpj+Osvi9lnDUwLUawbTQga33A=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    joblib
    llvmlite
    numba
    scikit-learn
    scipy
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pynndescent" ];

  meta = with lib; {
    description = "Nearest Neighbor Descent";
    homepage = "https://github.com/lmcinnes/pynndescent";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mic92 ];
  };
}
