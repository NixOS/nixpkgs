{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rfc8785";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "rfc8785.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-hMH//DpxgNoNLZJ8XL8SikcTfj0w0FvlBMfnPCkqzZ4=";
  };

  build-system = [
    flit-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rfc8785" ];

  meta = with lib; {
    description = "Module for RFC8785 (JSON Canonicalization Scheme)";
    homepage = "https://github.com/trailofbits/rfc8785.py";
    changelog = "https://github.com/trailofbits/rfc8785.py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
