{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "sabyenc3";
  version = "5.4.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-89ZfKnC8sT7xvq4P9rs7aa2uGElwNfjNT/5OWvGqL0E=";
  };

  # Tests are not included in pypi distribution
  doCheck = false;

  pythonImportsCheck = [ "sabyenc3" ];

<<<<<<< HEAD
  meta = {
    description = "yEnc Decoding for Python 3";
    homepage = "https://github.com/sabnzbd/sabyenc/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ lovek323 ];
=======
  meta = with lib; {
    description = "yEnc Decoding for Python 3";
    homepage = "https://github.com/sabnzbd/sabyenc/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ lovek323 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
