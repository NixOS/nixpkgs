{ lib
, buildPythonPackage
, fetchFromGitHub
# Python deps
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "blockfrost-python";
  version = "0.5.3";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "blockfrost";
    repo = "blockfrost-python";
    rev = "${version}";
    hash = "sha256-mQ8avjyLARJONYn18neCyuHEuv3ySyCNMe+P4+Dlxck=";
  };

  propagatedBuildInputs = [
    requests
    setuptools
  ];

  pythonImportsCheck = [ "blockfrost" ];

  meta = with lib; {
    description = "Python SDK for the Blockfrost.io API";
    homepage = "https://github.com/blockfrost/blockfrost-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ t4ccer ];
  };
}
