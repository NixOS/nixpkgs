{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fsspec,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  reflink,
  setuptools-scm,
  shortuuid,
}:

buildPythonPackage rec {
  pname = "dvc-objects";
<<<<<<< HEAD
  version = "5.2.0";
=======
  version = "5.1.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-objects";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-COrHD7RtmShdC7YWFc+S3xi/Xxt+Afrj3vaCLfE8t28=";
=======
    hash = "sha256-Lq881EnszwS+o8vaiiVgerdXAcalLT0PIJoW98+rw7w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --benchmark-skip" ""
  '';

  build-system = [ setuptools-scm ];

  dependencies = [ fsspec ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    reflink
    shortuuid
  ];

  pythonImportsCheck = [ "dvc_objects" ];

  disabledTestPaths = [
    # Disable benchmarking
    "tests/benchmarks/"
  ];

<<<<<<< HEAD
  meta = {
    description = "Library for DVC objects";
    homepage = "https://github.com/iterative/dvc-objects";
    changelog = "https://github.com/iterative/dvc-objects/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library for DVC objects";
    homepage = "https://github.com/iterative/dvc-objects";
    changelog = "https://github.com/iterative/dvc-objects/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
