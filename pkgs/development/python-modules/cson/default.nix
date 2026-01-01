{
  lib,
  buildPythonPackage,
  fetchPypi,
  speg,
}:

buildPythonPackage rec {
  pname = "cson";
  version = "0.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7owBZvzR9ReJiHGX4+g1Sse++jlvwpcGvOta8l7cngE=";
  };

  propagatedBuildInputs = [ speg ];

  pythonImportsCheck = [ "cson" ];

<<<<<<< HEAD
  meta = {
    description = "Python parser for the Coffeescript Object Notation (CSON)";
    homepage = "https://github.com/avakar/pycson";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ xworld21 ];
=======
  meta = with lib; {
    description = "Python parser for the Coffeescript Object Notation (CSON)";
    homepage = "https://github.com/avakar/pycson";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ xworld21 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
