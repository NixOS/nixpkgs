{ lib
, buildPythonPackage
, fetchPypi
, python
, nose
}:

buildPythonPackage rec {
  pname = "cchardet";
  version = "2.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h3wajwwgqpyb1q44lzr8djbcwr4y8cphph7kyscz90d83h4b5yc";
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
