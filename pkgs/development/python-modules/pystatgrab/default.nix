{
  lib,
  stdenv,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  libstatgrab,
  pkg-config,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pystatgrab";
  version = "0.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "libstatgrab";
    repo = "pystatgrab";
    rev = "PYSTATGRAB_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-B1PJFNhKJbRUfx0BqKeXQ29uCFaY/70N00gWCQ/22kI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'version = os.getenv("PYSTATGRAB_VERSION", VERSION),' 'version = "${finalAttrs.version}",'
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  buildInputs = [ libstatgrab ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "statgrab" ];

  meta = {
    description = "Python bindings for libstatgrab";
    homepage = "https://github.com/libstatgrab/pystatgrab";
    changelog = "https://github.com/libstatgrab/pystatgrab/blob/PYSTATGRAB_${
      lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }/NEWS";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
