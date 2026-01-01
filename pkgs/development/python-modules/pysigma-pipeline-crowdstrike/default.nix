{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "pysigma-pipeline-crowdstrike";
<<<<<<< HEAD
  version = "3.0.0";
  pyproject = true;

=======
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-crowdstrike";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-c7+4/55rrVVVdw2Yy8emoiWkyKlCgP4PKdAa1XW+aYM=";
  };

  pythonRelaxDeps = [ "pysigma" ];

=======
    hash = "sha256-WYgT0tRXdSR4qJA7UHotPn9qfnpaIJaqASBXVDG1kOU=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sigma.pipelines.crowdstrike" ];

  disabledTests = [
    # Windows binary not mocked
    "test_crowdstrike_pipeline_parentimage"
  ];

<<<<<<< HEAD
  meta = {
    description = "Library to support CrowdStrike pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-crowdstrike";
    changelog = "https://github.com/SigmaHQ/pySigma-pipeline-crowdstrike/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library to support CrowdStrike pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-crowdstrike";
    changelog = "https://github.com/SigmaHQ/pySigma-pipeline-crowdstrike/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
