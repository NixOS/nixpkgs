{ lib
, python
, buildPythonPackage
, fetchFromGitHub
, openmp
, ply
, gast
, numpy
, beniget
, xsimd
, isPy3k
, substituteAll
}:

let
  inherit (python) stdenv;

in buildPythonPackage rec {
  pname = "pythran";
  version = "0.13.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "pythran";
    rev = version;
    hash = "sha256-baDrReJgQXbaKA8KNhHiFjr0X34yb8WK/nUJmiM9EZs=";
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
    rm -r third_party/xsimd
    ln -s '${lib.getDev xsimd}'/include/xsimd third_party/
  '';

  propagatedBuildInputs = [
    ply
    gast
    numpy
    beniget
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
