{ lib
, buildPythonPackage
, fetchPypi
, python
, nose
}:

buildPythonPackage rec {
  pname = "cchardet";
  version = "2.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c428b6336545053c2589f6caf24ea32276c6664cb86db817e03a94c60afa0eaf";
  };

  checkInputs = [ nose ];
  checkPhase = ''
    ${python.interpreter} setup.py nosetests
  '';

  meta = {
    description = "High-speed universal character encoding detector";
    homepage = "https://github.com/PyYoshi/cChardet";
    license = lib.licenses.mpl11;
    maintainers = with lib.maintainers; [ ivan ];
  };
}
