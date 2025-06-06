{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  pythonAtLeast,
  setuptools,
  gmp,
}:

buildPythonPackage rec {
  pname = "gmpy";
  version = "1.17";
  pyproject = true;

  # Python 3.11 has finally made changes to its C API for which gmpy 1.17,
  # published in 2013, would require patching. It seems unlikely that any
  # patches will be forthcoming.
  disabled = isPyPy || pythonAtLeast "3.11";

  src = fetchFromGitHub {
    owner = "aleaxit";
    repo = "gmpy";
    rev = "refs/tags/gmpy_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-kMidOjhKJlDRu2qaiq9c+XcwD1tNAoPhRTvvGcOJe8I=";
  };

  build-system = [ setuptools ];

  buildInputs = [ gmp ];

  pythonImportsCheck = [ "gmpy" ];

  meta = {
    description = "GMP or MPIR interface to Python 2.4+ and 3.x";
    homepage = "https://github.com/aleaxit/gmpy/";
    license = lib.licenses.lgpl21Plus;
  };
}
