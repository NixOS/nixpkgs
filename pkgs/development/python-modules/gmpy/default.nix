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
  version = "2.2.2";
  pyproject = true;

  # Python 3.11 has finally made changes to its C API for which gmpy 1.17,
  # published in 2013, would require patching. It seems unlikely that any
  # patches will be forthcoming.
  disabled = isPyPy || pythonAtLeast "3.11";

  src = fetchFromGitHub {
    owner = "aleaxit";
    repo = "gmpy";
    tag = "v${version}";
    hash = "sha256-joeHec/d82sovfASCU3nlNL6SaThnS/XYPqujiZ9h8s=";
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
