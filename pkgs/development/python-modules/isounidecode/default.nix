{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "isounidecode";
  version = "0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TbCpYsY0GCbJpprKq8L5I6WxJNU6M1voku8pFzvDHFs=";
  };

  pythonImportsCheck = [ "isounidecode" ];

  # no real tests included, fails to run
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Python package for conversion and transliteration of unicode into ascii or iso-8859-1";
    homepage = "https://github.com/redvasily/isounidecode";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Python package for conversion and transliteration of unicode into ascii or iso-8859-1";
    homepage = "https://github.com/redvasily/isounidecode";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
