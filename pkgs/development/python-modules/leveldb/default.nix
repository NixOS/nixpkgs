{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "leveldb";
  version = "0.201";

  pyproject = true;

  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cffe776842917e09f073bd6ea5856c64136aebddbe51bd17ea29913472fecbf";
  };

  nativeBuildInputs = [ setuptools ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://code.google.com/archive/p/py-leveldb/";
    description = "Thread-safe Python bindings for LevelDB";
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.aanderse ];
=======
    license = licenses.bsd3;
    maintainers = [ maintainers.aanderse ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
