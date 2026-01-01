{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packageurl-python,
  pythonOlder,
  rich,
  setuptools,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "csaf-tool";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "anthonyharrison";
    repo = "csaf";
    tag = "${version}";
    hash = "sha256-LR6r03z0nvvAQgFHaTWfukoJmLZ6SLPXfbp/G8N/HtM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    packageurl-python
    rich
  ];

  # has not tests
  doCheck = false;

  pythonImportsCheck = [ "csaf" ];

  nativeCheckInputs = [ versionCheckHook ];

<<<<<<< HEAD
  meta = {
    description = "CSAF generator and validator";
    homepage = "https://github.com/anthonyharrison/csaf";
    changelog = "https://github.com/anthonyharrison/csaf/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ teatwig ];
=======
  meta = with lib; {
    description = "CSAF generator and validator";
    homepage = "https://github.com/anthonyharrison/csaf";
    changelog = "https://github.com/anthonyharrison/csaf/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teatwig ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
