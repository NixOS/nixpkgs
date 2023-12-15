{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "krakenex";
  version = "2.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "veox";
    repo = "python3-krakenex";
    rev = "v${version}";
    sha256 = "0j8qmpk6lm57h80i5njhgvm1qnxllm18dlqxfd4kyxdb93si4z2p";
  };

  propagatedBuildInputs = [
    requests
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "krakenex" ];

  meta = with lib; {
    description = "Kraken.com cryptocurrency exchange API";
    homepage = "https://github.com/veox/python3-krakenex";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
