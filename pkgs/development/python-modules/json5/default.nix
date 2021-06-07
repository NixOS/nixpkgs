{ buildPythonPackage
, fetchFromGitHub
, hypothesis
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "json5";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "dpranke";
    repo = "pyjson5";
    rev = "v${version}";
    sha256 = "sha256-VkJnZG1BuC49/jJuwObbqAF48CtbWU9rDEYW4Dg0w4U=";
  };

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/dpranke/pyjson5";
    description = "A Python implementation of the JSON5 data format";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
  };
}
