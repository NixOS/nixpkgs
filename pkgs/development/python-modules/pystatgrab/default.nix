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
  wheel,
  darwin,
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

  build-system = [
    setuptools
    wheel
  ];

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  buildInputs = [
    libstatgrab
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ IOKit ]);

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "statgrab" ];

  meta = with lib; {
    description = "Python bindings for libstatgrab";
    homepage = "https://github.com/libstatgrab/pystatgrab";
    changelog = "https://github.com/libstatgrab/pystatgrab/blob/PYSTATGRAB_${
      lib.replaceStrings [ "." ] [ "_" ] version
    }/NEWS";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ fab ];
  };
}
