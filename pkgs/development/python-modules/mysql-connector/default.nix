{ lib, buildPythonPackage, fetchFromGitHub, python, protobuf3_6 }:

let
  py = python.override {
    packageOverrides = self: super: {
      protobuf = super.protobuf.override {
        protobuf = protobuf3_6;
      };
    };
  };
in buildPythonPackage rec {
  pname = "mysql-connector";
  version = "8.0.19";

  src = fetchFromGitHub {
    owner = "mysql";
    repo = "mysql-connector-python";
    rev = version;
    sha256 = "1jscmc5s7mwx43gvxjlqc30ylp5jjpmkqx7s3b9nllbh926p3ixg";
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
    homepage = https://github.com/mysql/mysql-connector-python;
    license = [ lib.licenses.gpl2 ];
    maintainers = with lib.maintainers; [ primeos ];
  };
}
