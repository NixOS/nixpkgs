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
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "pythran";
    rev = version;
    hash = "sha256-in0ty0aBAIx7Is13hjiHZGS8eKbhxb6TL3bENzfx5vQ=";
  };

  patches = [
    # Hardcode path to mp library
    (substituteAll {
      src = ./0001-hardcode-path-to-libgomp.patch;
      gomp = "${if stdenv.cc.isClang then openmp else stdenv.cc.cc.lib}/lib/libgomp${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
    (fetchpatch {
      # Python 3.12 support
      url = "https://github.com/serge-sans-paille/pythran/commit/258ab9aaf26172f669eab1bf2a346b5f65db3ac0.patch";
      hash = "sha256-T+FLptDYIgzHBSXShULqHr/G8ttBFamq1M5JlB2HxDM=";
    })
  ];

  # xsimd: unvendor this header-only C++ lib
  postPatch = ''
    rm -r third_party/xsimd
    ln -s '${lib.getDev xsimd}'/include/xsimd third_party/
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
  };
}
