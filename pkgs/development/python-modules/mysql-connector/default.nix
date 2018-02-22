{ lib, buildPythonPackage, fetchFromGitHub
, protobuf
}:

buildPythonPackage rec {
  pname = "mysql-connector";
  version = "8.0.6";

  src = fetchFromGitHub {
    owner = "mysql";
    repo = "mysql-connector-python";
    rev = version;
    sha256 = "1ygr7va56da12yp3gr7kzss9zgbs28q2lmdkw16rpxj108id4rkp";
  };

  propagatedBuildInputs = [ protobuf ];

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
