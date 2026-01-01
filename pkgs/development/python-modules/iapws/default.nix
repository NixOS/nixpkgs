{
  lib,
  buildPythonPackage,
  fetchPypi,
  scipy,
}:

buildPythonPackage rec {
  pname = "iapws";
  version = "1.5.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nw+qOaln12/F5flfYdki4TVFMZLgK/h10HJC8T1uqlU=";
  };

  propagatedBuildInputs = [ scipy ];

<<<<<<< HEAD
  meta = {
    description = "Python implementation of standard from IAPWS";
    homepage = "https://github.com/jjgomera/iapws";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ dawidsowa ];
=======
  meta = with lib; {
    description = "Python implementation of standard from IAPWS";
    homepage = "https://github.com/jjgomera/iapws";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dawidsowa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
