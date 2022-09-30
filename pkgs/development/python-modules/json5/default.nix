{ buildPythonPackage
, fetchFromGitHub
, hypothesis
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "json5";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "dpranke";
    repo = "pyjson5";
    rev = "v${version}";
    hash = "sha256-0ommoTv5q7YuLNF+ZPWW/Xg/8CwnPrF7rXJ+eS0joUs=";
  };

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "json5"
  ];

  meta = with lib; {
    homepage = "https://github.com/dpranke/pyjson5";
    description = "A Python implementation of the JSON5 data format";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
  };
}
