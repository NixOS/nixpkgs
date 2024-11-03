{
  lib,
  aiofiles,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "acunetix";
  version = "0.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hikariatama";
    repo = "acunetix";
    # https://github.com/hikariatama/acunetix/issues/1
    rev = "67584746731b9f7abd1cf10ff8161eb3085800ce";
    hash = "sha256-ycdCz8CNSP0USxv657jf6Vz4iF//reCeO2tG+und86A=";
  };

  propagatedBuildInputs = [
    aiofiles
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "acunetix" ];

  meta = with lib; {
    description = "Acunetix Web Vulnerability Scanner SDK for Python";
    homepage = "https://github.com/hikariatama/acunetix";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
