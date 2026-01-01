{
  lib,
  stdenv,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  libstatgrab,
  pkg-config,
  pythonOlder,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pystatgrab";
  version = "0.7.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "libstatgrab";
    repo = "pystatgrab";
    rev = "PYSTATGRAB_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-0FDhkIK8jy3/SFmCzrl9l4RTeIKDjO0o5UoODx6Wnfs=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  buildInputs = [ libstatgrab ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "statgrab" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python bindings for libstatgrab";
    homepage = "https://github.com/libstatgrab/pystatgrab";
    changelog = "https://github.com/libstatgrab/pystatgrab/blob/PYSTATGRAB_${
      lib.replaceStrings [ "." ] [ "_" ] version
    }/NEWS";
<<<<<<< HEAD
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
=======
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
