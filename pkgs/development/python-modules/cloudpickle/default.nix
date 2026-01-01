{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # build-system
  flit-core,

  # tests
<<<<<<< HEAD
=======
  psutil,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cloudpickle";
<<<<<<< HEAD
  version = "3.1.2";
  pyproject = true;

=======
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "cloudpipe";
    repo = "cloudpickle";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-BsCOEpNCNqq8PS+SdbzF1wq0LXEmtcHJs0pdt2qFw/w=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
=======
    hash = "sha256-e8kEznjuIrdjNsXwXJO3lcEEpiCR+UQzXnGrTarUb5E=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [
    psutil
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cloudpickle" ];

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'psutil'
<<<<<<< HEAD
    # (because _make_cwd_env() overwrites $PYTHONPATH)
    "tests/cloudpickle_test.py"
  ];

  meta = {
    changelog = "https://github.com/cloudpipe/cloudpickle/blob/${src.tag}/CHANGES.md";
    description = "Extended pickling support for Python objects";
    homepage = "https://github.com/cloudpipe/cloudpickle";
    license = lib.licenses.bsd3;
=======
    "tests/cloudpickle_test.py"
  ];

  meta = with lib; {
    changelog = "https://github.com/cloudpipe/cloudpickle/blob/${src.tag}/CHANGES.md";
    description = "Extended pickling support for Python objects";
    homepage = "https://github.com/cloudpipe/cloudpickle";
    license = with licenses; [ bsd3 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
