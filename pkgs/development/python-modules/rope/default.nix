{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "rope";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a108c445e1cd897fe19272ab7877d172e7faf3d4148c80e7d20faba42ea8f7b2";
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
