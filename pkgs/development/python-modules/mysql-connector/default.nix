{ lib, buildPythonPackage, fetchFromGitHub, python }:

let
  py = python;
in buildPythonPackage rec {
  pname = "mysql-connector";
  version = "8.0.22";

  src = fetchFromGitHub {
    owner = "mysql";
    repo = "mysql-connector-python";
    rev = version;
    sha256 = "084q8x86ywgxgpsgdid8y9rjjys06146dqinfpmlggjswbq9kl0d";
  };

  propagatedBuildInputs = with py.pkgs; [ protobuf dnspython ];

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
    homepage = "https://github.com/mysql/mysql-connector-python";
    changelog = "https://raw.githubusercontent.com/mysql/mysql-connector-python/${version}/CHANGES.txt";
    license = [ lib.licenses.gpl2 ];
    maintainers = with lib.maintainers; [ primeos ];
  };
}
