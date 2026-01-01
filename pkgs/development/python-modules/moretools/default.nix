{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  path,
  zetup,
  pytest,
  decorator,
}:

buildPythonPackage rec {
  pname = "moretools";
  version = "0.1.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73b0469d4f1df6d967508103473f0b1524708adbff71f8f90ef71d9a44226b22";
  };

  checkPhase = ''
    py.test test
  '';

  nativeBuildInputs = [ zetup ];
  nativeCheckInputs = [
    six
    path
    pytest
  ];
  propagatedBuildInputs = [ decorator ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = ''
      Many more basic tools for python 2/3 extending itertools, functools, operator and collections
    '';
    homepage = "https://bitbucket.org/userzimmermann/python-moretools";
<<<<<<< HEAD
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
=======
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
