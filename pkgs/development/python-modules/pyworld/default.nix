{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  cython,
}:

buildPythonPackage rec {
  pname = "pyworld";
  version = "0.3.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G5PlPN22eg5PqjTWz5GaxsZi/rHIwO2QHXG1las5aqM=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "pyworld" ];

<<<<<<< HEAD
  meta = {
    description = "PyWorld is a Python wrapper for WORLD vocoder";
    homepage = "https://github.com/JeremyCCHsu/Python-Wrapper-for-World-Vocoder";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mic92 ];
=======
  meta = with lib; {
    description = "PyWorld is a Python wrapper for WORLD vocoder";
    homepage = "https://github.com/JeremyCCHsu/Python-Wrapper-for-World-Vocoder";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
