{ buildPythonPackage
, fetchFromGitHub
, hypothesis
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "json5";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "dpranke";
    repo = "pyjson5";
    rev = "v${version}";
    sha256 = "sha256-RJj5KvLKq43tRuTwxq/mB+sU35xTQwZqg/jpdYcMP6A=";
  };

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "json5" ];

  meta = with lib; {
    homepage = "https://github.com/dpranke/pyjson5";
    description = "A Python implementation of the JSON5 data format";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
  };
}
