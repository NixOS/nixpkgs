{ lib
, python
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, isPy3k
, substituteAll

# build-system
, setuptools

# native dependencies
, openmp
, xsimd

# dependencies
, ply
, gast
, numpy
, beniget
}:

let
  inherit (python) stdenv;

in buildPythonPackage rec {
  pname = "pythran";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "pythran";
    rev = version;
    hash = "sha256-TpD8YZnnv48PKYrUqR0/qvJG1XRbcMBcrkcERh6Q4q0=";
  };

  patches = [
    # Hardcode path to mp library
    (substituteAll {
      src = ./0001-hardcode-path-to-libgomp.patch;
      gomp = "${if stdenv.cc.isClang then openmp else stdenv.cc.cc.lib}/lib/libgomp${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  # xsimd: unvendor this header-only C++ lib
  postPatch = ''
    rm -r pythran/xsimd
    ln -s '${lib.getDev xsimd}'/include/xsimd pythran/
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    ply
    gast
    numpy
    beniget
    setuptools
  ];

  pythonImportsCheck = [
    "pythran"
    "pythran.backend"
    "pythran.middlend"
    "pythran.passmanager"
    "pythran.toolchain"
    "pythran.spec"
  ];

  # Test suite is huge and has a circular dependency on scipy.
  doCheck = false;

  disabled = !isPy3k;

  meta = {
    description = "Ahead of Time compiler for numeric kernels";
    homepage = "https://github.com/serge-sans-paille/pythran";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
