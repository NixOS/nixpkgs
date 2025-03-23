{
  lib,
  buildPythonPackage,
  etcd,
  fetchFromGitHub,
  grpcio,
  hypothesis,
  mock,
  pifpaf,
  protobuf,
  pytestCheckHook,
  six,
  tenacity,
  setuptools,
}:

buildPythonPackage rec {
  pname = "etcd3";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kragniz";
    repo = "python-etcd3";
    tag = "v${version}";
    hash = "sha256-YM72+fkCDYXl6DORJa/O0sqXqHDWQcFLv2ifQ9kEHBo=";
  };

  build-system = [ setuptools ];

  env = {
    # make protobuf compatible with old versions
    # https://developers.google.com/protocol-buffers/docs/news/2022-05-06#python-updates
    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";
  };

  dependencies = [
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

  pythonImportsCheck = [ "etcd3" ];

  meta = {
    description = "Python client for the etcd API v3";
    homepage = "https://github.com/kragniz/python-etcd3";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
