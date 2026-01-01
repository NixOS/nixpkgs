{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylsqpack";
  version = "0.3.22";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tn9xGzyDcNn0D39/U2qmAY2JAPoJ+kn3Lww/E4hs7No=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pylsqpack" ];

<<<<<<< HEAD
  meta = {
    description = "Python wrapper for the ls-qpack QPACK library";
    homepage = "https://github.com/aiortc/pylsqpack";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
=======
  meta = with lib; {
    description = "Python wrapper for the ls-qpack QPACK library";
    homepage = "https://github.com/aiortc/pylsqpack";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
