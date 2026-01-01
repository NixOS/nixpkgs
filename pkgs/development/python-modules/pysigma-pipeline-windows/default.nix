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
  pname = "pysigma-pipeline-windows";
<<<<<<< HEAD
  version = "2.0.0";
  pyproject = true;
=======
  version = "1.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-windows";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-2S4vWneBNKq/FwhDs4Iref9hvEbcqvG/MOSTMYd7crU=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];
=======
    hash = "sha256-Ss0OMd8urCYQUlvsm/m8Kz0jY4pVSEoZuLxs1JLWxQA=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ pysigma ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sigma.pipelines.windows" ];

<<<<<<< HEAD
  meta = {
    description = "Library to support Windows service pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-windows";
    changelog = "https://github.com/SigmaHQ/pySigma-pipeline-windows/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library to support Windows service pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-windows";
    changelog = "https://github.com/SigmaHQ/pySigma-pipeline-windows/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
