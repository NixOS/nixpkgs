{ stdenv, buildPythonPackage, fetchPypi, pythonAtLeast, nose }:

buildPythonPackage rec {
  pname = "rope";
  version = "0.17.0";

  disabled = pythonAtLeast "3.8";  # 0.17 should support Python 3.8

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qa9nqryp05ah9b4r8cy5ph31kr9cm4ak79pvzbg7p23bxqdd2k5";
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
