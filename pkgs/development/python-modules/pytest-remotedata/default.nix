{ lib
, buildPythonPackage
, fetchPypi
, six
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-remotedata";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "66920bf1c62928b079d0e611379111a0d49f10a9509ced54c8269514ccce6ee3";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    # these tests require a network connection
    pytest --ignore tests/test_strict_check.py
  '';

  meta = with lib; {
    description = "Pytest plugin for controlling remote data access";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
