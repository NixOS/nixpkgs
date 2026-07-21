{
  lib,
  aiofiles,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "acunetix";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hikariatama";
    repo = "acunetix";
    # https://github.com/hikariatama/acunetix/issues/1
    rev = "67584746731b9f7abd1cf10ff8161eb3085800ce";
    hash = "sha256-ycdCz8CNSP0USxv657jf6Vz4iF//reCeO2tG+und86A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "acunetix" ];

  meta = {
    description = "Acunetix Web Vulnerability Scanner SDK for Python";
    homepage = "https://github.com/hikariatama/acunetix";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
