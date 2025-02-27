{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  wrapt,
}:

buildPythonPackage rec {
  pname = "aiounittest";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kwarunek";
    repo = "aiounittest";
    tag = version;
    hash = "sha256-hcfcB2SMduTopqdRdMi63UTTD7BWc5g2opAfahWXjlw=";
  };

  build-system = [ setuptools ];

  dependencies = [ wrapt ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aiounittest" ];

  meta = with lib; {
    changelog = "https://github.com/kwarunek/aiounittest/releases/tag/${src.tag}";
    description = "Test asyncio code more easily";
    homepage = "https://github.com/kwarunek/aiounittest";
    license = licenses.mit;
    maintainers = [ ];
  };
}
