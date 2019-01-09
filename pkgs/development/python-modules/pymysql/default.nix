{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "PyMySQL";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ry8lxgdc1p3k7gbw20r405jqi5lvhi5wk83kxdbiv8xv3f5kh6q";
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
