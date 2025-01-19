{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # Python deps
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "blockfrost-python";
  version = "0.6.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "blockfrost";
    repo = "blockfrost-python";
    tag = version;
    hash = "sha256-mN26QXxizDR+o2V5C2MlqVEbRns1BTmwZdUnnHNcFzw=";
  };

  propagatedBuildInputs = [
    requests
    setuptools
  ];

  pythonImportsCheck = [ "blockfrost" ];

  meta = {
    description = "Python SDK for the Blockfrost.io API";
    homepage = "https://github.com/blockfrost/blockfrost-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ t4ccer ];
  };
}
