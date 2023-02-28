{ lib
, buildPythonPackage
, fetchFromGitHub

# propagates
, grpcio
, protobuf
, six
, tenacity
}:

buildPythonPackage rec {
  pname = "etcd3";
  version = "0.12.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kragniz";
    repo = "python-etcd3";
    rev = "refs/tags/v${version}";
    hash = "sha256-YM72+fkCDYXl6DORJa/O0sqXqHDWQcFLv2ifQ9kEHBo=";
  };

  propagatedBuildInputs = [
    grpcio
    protobuf
    six
    tenacity
  ];

  pythonImportsCheck = [
    "etcd3"    
  ];

  doCheck = false; # requires running etcd instance

  meta = with lib; {
    description = "Python client for the etcd API v3";
    homepage = "https://github.com/kragniz/python-etcd3";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
