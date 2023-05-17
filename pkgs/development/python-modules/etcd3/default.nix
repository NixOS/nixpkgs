{ lib
, buildPythonPackage
, etcd
, fetchFromGitHub
, grpcio
, hypothesis
, mock
, pifpaf
, protobuf
, pytestCheckHook
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

  # various failures and incompatible with newer hypothesis versions
  doCheck = false;

  nativeCheckInputs = [
    etcd
    hypothesis
    mock
    pifpaf
    pytestCheckHook
  ];

  preCheck = ''
    pifpaf -e PYTHON run etcd --cluster
  '';

  pythonImportsCheck = [
    "etcd3"
  ];

  meta = with lib; {
    description = "Python client for the etcd API v3";
    homepage = "https://github.com/kragniz/python-etcd3";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
