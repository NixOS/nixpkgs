{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pysigma-pipeline-sysmon,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "pysigma-backend-qradar";
  version = "0.3.3";
<<<<<<< HEAD
  pyproject = true;
=======
  format = "pyproject";

  disabled = pythonOlder "3.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "nNipsx-Sec";
    repo = "pySigma-backend-qradar";
    tag = "v${version}";
    hash = "sha256-VymaxX+iqrRlf+WEt4xqEvNt5kg8xI5O/MoYahayu0o=";
  };

  pythonRelaxDeps = [ "pysigma" ];

<<<<<<< HEAD
  build-system = [ poetry-core ];

  dependencies = [ pysigma ];
=======
  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [ pysigma ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = [
    pysigma-pipeline-sysmon
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sigma.backends.qradar" ];

<<<<<<< HEAD
  meta = {
    description = "Library to support Qradar for pySigma";
    homepage = "https://github.com/nNipsx-Sec/pySigma-backend-qradar";
    changelog = "https://github.com/nNipsx-Sec/pySigma-backend-qradar/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library to support Qradar for pySigma";
    homepage = "https://github.com/nNipsx-Sec/pySigma-backend-qradar";
    changelog = "https://github.com/nNipsx-Sec/pySigma-backend-qradar/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
