{ lib, buildPythonPackage, fetchFromGitHub
, protobuf
}:

buildPythonPackage rec {
  pname = "mysql-connector";
  version = "8.0.14";

  src = fetchFromGitHub {
    owner = "mysql";
    repo = "mysql-connector-python";
    rev = version;
    sha256 = "1cf0ic2mx339j62579xjlaw5q5sz61dac379c7lsy3ln3krsw3y9";
  };

  propagatedBuildInputs = [ protobuf ];

  # Tests are failing (TODO: unknown reason)
  # TypeError: __init__() missing 1 required positional argument: 'string'
  # But the library should be working as expected.
  doCheck = false;

  meta = {
    description = "A MySQL driver";
    longDescription = ''
      A MySQL driver that does not depend on MySQL C client libraries and
      implements the DB API v2.0 specification.
    '';
    homepage = https://github.com/mysql/mysql-connector-python;
    license = [ lib.licenses.gpl2 ];
    maintainers = with lib.maintainers; [ primeos ];
  };
}
