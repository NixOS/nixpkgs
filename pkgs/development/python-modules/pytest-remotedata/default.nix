{ lib
, buildPythonPackage
, fetchPypi
, six
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-remotedata";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e20c58d4b7c359c4975dc3c3d3d67be0905180d2368be0be3ae09b15a136cfc0";
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
