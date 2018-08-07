{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "PyMySQL";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gvi63f1zq1bbd30x28kqyx351hal1yc323ckp0mihainb5n1iwy";
  };

  propagatedBuildInputs = [ cryptography ];

  # Wants to connect to MySQL
  doCheck = false;

  meta = with lib; {
    description = "Pure Python MySQL Client";
    homepage = https://github.com/PyMySQL/PyMySQL;
    license = licenses.mit;
    maintainers = [ maintainers.kalbasit ];
  };
}
