{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hl7";
  version = "0.4.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "johnpaulett";
    repo = "python-hl7";
    tag = version;
    hash = "sha256-9uFdyL4+9KSWXflyOMOeUudZTv4NwYPa0ADNTmuVbqo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hl7" ];

  meta = with lib; {
    description = "Simple library for parsing messages of Health Level 7 (HL7) version 2.x into Python objects";
    mainProgram = "mllp_send";
    homepage = "https://python-hl7.readthedocs.org";
    changelog = "https://python-hl7.readthedocs.io/en/latest/changelog.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
