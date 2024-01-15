{ lib
, buildPythonPackage
, fetchPypi
}:
buildPythonPackage rec {
  pname = "pytweening";
  version = "1.0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dnE08b9Xt2wc6faS3Rz8d22aJ53mck6NBIVFCP1+3ts=";
  };

  pythonImportsCheck = [ "pytweening" ];
  checkPhase = ''
    python -m unittest tests.basicTests
  '';

  meta = with lib; {
    description = "Set of tweening / easing functions implemented in Python";
    homepage = "https://github.com/asweigart/pytweening";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lucasew ];
  };
}
