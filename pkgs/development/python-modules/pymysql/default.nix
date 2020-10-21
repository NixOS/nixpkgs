{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "PyMySQL";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "263040d2779a3b84930f7ac9da5132be0fefcd6f453a885756656103f8ee1fdd";
  };

  propagatedBuildInputs = [ cryptography ];

  # Wants to connect to MySQL
  doCheck = false;

  meta = with lib; {
    description = "Pure Python MySQL Client";
    homepage = "https://github.com/PyMySQL/PyMySQL";
    license = licenses.mit;
    maintainers = [ maintainers.kalbasit ];
  };
}
