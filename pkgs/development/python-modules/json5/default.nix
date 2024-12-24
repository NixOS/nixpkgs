{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "json5";
  version = "0.9.25";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dpranke";
    repo = "pyjson5";
    rev = "refs/tags/v${version}";
    hash = "sha256-2JAZHayPyi2RI4apODQ9QDXSUI8n54SwQAxZiBhuJrE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "json5" ];

  meta = with lib; {
    description = "Python implementation of the JSON5 data format";
    homepage = "https://github.com/dpranke/pyjson5";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
    mainProgram = "pyjson5";
  };
}
