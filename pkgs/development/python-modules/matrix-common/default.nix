{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  attrs,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "matrix-common";
  version = "1.3.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "matrix_common";
    inherit version;
    hash = "sha256-YuEhzM2fJDQXtX7DenbcRK6xmKelxnr9a4J1mS/yq9E=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ attrs ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "matrix_common" ];

<<<<<<< HEAD
  meta = {
    description = "Common utilities for Synapse, Sydent and Sygnal";
    homepage = "https://github.com/matrix-org/matrix-python-common";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sumnerevans ];
=======
  meta = with lib; {
    description = "Common utilities for Synapse, Sydent and Sygnal";
    homepage = "https://github.com/matrix-org/matrix-python-common";
    license = licenses.asl20;
    maintainers = with maintainers; [ sumnerevans ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
