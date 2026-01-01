{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  taglib,
  cython,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytaglib";
<<<<<<< HEAD
  version = "3.1.0";
=======
  version = "3.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "supermihi";
    repo = "pytaglib";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-A+RH9mWwtvhBDqTfvOK1RbsPP+0srF9h4mIknAHbG50=";
=======
    hash = "sha256-K9K30NFBcmxlYDQQ4YUhGzaPNVmLt0/L0JDrCtyKwLA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [
    cython
    taglib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "taglib" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python bindings for the Taglib audio metadata library";
    mainProgram = "pyprinttags";
    homepage = "https://github.com/supermihi/pytaglib";
    changelog = "https://github.com/supermihi/pytaglib/blob/${src.tag}/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mrkkrp ];
=======
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mrkkrp ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
