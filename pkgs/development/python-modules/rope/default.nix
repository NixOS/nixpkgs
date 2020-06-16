{ stdenv, buildPythonPackage, fetchPypi, pythonAtLeast, nose }:

buildPythonPackage rec {
  pname = "rope";
  version = "0.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "658ad6705f43dcf3d6df379da9486529cf30e02d9ea14c5682aa80eb33b649e1";
  };

  checkInputs = [ nose ];
  checkPhase = ''
    # tracked upstream here https://github.com/python-rope/rope/issues/247
    NOSE_IGNORE_FILES=type_hinting_test.py nosetests ropetest
  '';

  meta = with stdenv.lib; {
    description = "Python refactoring library";
    homepage = "https://github.com/python-rope/rope";
    maintainers = with maintainers; [ goibhniu ];
    license = licenses.gpl2;
  };
}
