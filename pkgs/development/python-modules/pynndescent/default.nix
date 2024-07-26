{ lib
, buildPythonPackage
, fetchPypi
, importlib-metadata
, joblib
, llvmlite
, numba
, scikit-learn
, scipy
, setuptools
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynndescent";
  version = "0.5.11";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b0TO2dWp2iyH2bL/8wu1MIVAwGV2BeTVzeftMnW7rVA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    joblib
    llvmlite
    numba
    scikit-learn
    scipy
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pynndescent"
  ];

  meta = with lib; {
    description = "Nearest Neighbor Descent";
    homepage = "https://github.com/lmcinnes/pynndescent";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mic92 ];
  };
}
