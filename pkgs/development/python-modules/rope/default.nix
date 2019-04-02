{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "rope";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bwayj0hh459s3yh0sdrxksr9wfilgi3a49izfaj06kvgyladif5";
  };

  checkInputs = [ nose ];
  checkPhase = ''
    # tracked upstream here https://github.com/python-rope/rope/issues/247
    NOSE_IGNORE_FILES=type_hinting_test.py nosetests ropetest
  '';

  meta = with stdenv.lib; {
    description = "Python refactoring library";
    homepage = https://github.com/python-rope/rope;
    maintainers = with maintainers; [ goibhniu ];
    license = licenses.gpl2;
  };
}
