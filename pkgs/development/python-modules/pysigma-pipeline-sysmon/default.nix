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
  pname = "pysigma-pipeline-sysmon";
<<<<<<< HEAD
  version = "2.0.0";
  pyproject = true;

=======
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-sysmon";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-W0KNsawcJ1XmQ2Tmh+aD8EUL2LenCQUEUgx9shQhRDQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];
=======
    hash = "sha256-/WBHu1pFEiVPJQ97xEwjJJ92h9kHzTBPgmfQrR+RZjA=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ pysigma ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sigma.pipelines.sysmon" ];

<<<<<<< HEAD
  meta = {
    description = "Library to support Sysmon pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-sysmon";
    changelog = "https://github.com/SigmaHQ/pySigma-pipeline-sysmon/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library to support Sysmon pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-sysmon";
    changelog = "https://github.com/SigmaHQ/pySigma-pipeline-sysmon/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
