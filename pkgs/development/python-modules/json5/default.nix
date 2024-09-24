{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "json5";
  version = "0.9.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dpranke";
    repo = "pyjson5";
    rev = "v${version}";
    hash = "sha256-cshP1kraLENqWuQTlm4HPAP/0ywRRLFOJI8mteWcjR4=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "json5" ];

  meta = with lib; {
    homepage = "https://github.com/dpranke/pyjson5";
    description = "Python implementation of the JSON5 data format";
    mainProgram = "pyjson5";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
  };
}
