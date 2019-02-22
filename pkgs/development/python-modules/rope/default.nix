{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "rope";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "031eb54b3eeec89f4304ede816995ed2b93a21e6fba16bd02aff10a0d6c257b7";
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
