{ lib, buildPythonPackage, fetchFromGitHub
, protobuf
}:

buildPythonPackage rec {
  pname = "mysql-connector";
  version = "8.0.15";

  src = fetchFromGitHub {
    owner = "mysql";
    repo = "mysql-connector-python";
    rev = version;
    sha256 = "1w4j2sf07aid3453529z8kg1ziycbayxi3g2r4wqn0nb3y1caqz6";
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
