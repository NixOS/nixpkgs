{ lib
, buildPythonPackage
, fetchPypi
, python
, nose
}:

buildPythonPackage rec {
  pname = "cchardet";
  version = "2.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "240efe3f255f916769458343840b9c6403cf3192720bc5129792cbcb88bf72fb";
  };

  checkInputs = [ nose ];
  checkPhase = ''
    ${python.interpreter} setup.py nosetests
  '';

  meta = {
    description = "High-speed universal character encoding detector";
    homepage = https://github.com/PyYoshi/cChardet;
    license = lib.licenses.mpl11;
    maintainers = with lib.maintainers; [ ivan ];
  };
}
