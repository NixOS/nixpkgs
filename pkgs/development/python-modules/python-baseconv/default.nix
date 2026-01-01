{
  buildPythonPackage,
  fetchPypi,
  lib,
}:
buildPythonPackage rec {
  pname = "python-baseconv";
  version = "1.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0539f8bd0464013b05ad62e0a1673f0ac9086c76b43ebf9f833053527cd9931b";
  };

  pythonImportsCheck = [ "baseconv" ];

<<<<<<< HEAD
  meta = {
    description = "Python module to convert numbers from base 10 integers to base X strings and back again";
    homepage = "https://github.com/semente/python-baseconv";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ rakesh4g ];
=======
  meta = with lib; {
    description = "Python module to convert numbers from base 10 integers to base X strings and back again";
    homepage = "https://github.com/semente/python-baseconv";
    license = licenses.psfl;
    maintainers = with maintainers; [ rakesh4g ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
