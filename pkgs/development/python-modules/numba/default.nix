{ lib
, stdenv
, pythonAtLeast
, pythonOlder
, fetchPypi
, python
, buildPythonPackage
, numpy
, llvmlite
, setuptools
, libcxx
, substituteAll

# CUDA-only dependencies:
, addOpenGLRunpath ? null
, cudaPackages ? {}

# CUDA flags:
, cudaSupport ? false
}:

let
  inherit (cudaPackages) cudatoolkit;
in buildPythonPackage rec {
  version = "0.55.2";
  pname = "numba";
  disabled = pythonOlder "3.6" || pythonAtLeast "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5CjZ4R2bpZKEnMyfegCQA+t9MGEgB+Nlr+dDznEYxvQ=";
  };

  postPatch = ''
    # numpy
    substituteInPlace setup.py \
      --replace "1.22" "2"

    substituteInPlace numba/__init__.py \
      --replace "(1, 21)" "(2, 0)"
  '';

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${lib.getDev libcxx}/include/c++/v1";

  propagatedBuildInputs = [
    numpy
    llvmlite
    setuptools
  ] ++ lib.optionals cudaSupport [
    cudatoolkit
    cudatoolkit.lib
  ];

  nativeBuildInputs = lib.optional cudaSupport [
    addOpenGLRunpath
  ];

  patches = lib.optionals cudaSupport [
    (substituteAll {
      src = ./cuda_path.patch;
      cuda_toolkit_path = cudatoolkit;
      cuda_toolkit_lib_path = cudatoolkit.lib;
    })
  ];

  postFixup = lib.optionalString cudaSupport ''
    find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      addOpenGLRunpath "$lib"
      patchelf --set-rpath "${cudatoolkit}/lib:${cudatoolkit.lib}/lib:$(patchelf --print-rpath "$lib")" "$lib"
    done
  '';

  # Copy test script into $out and run the test suite.
  checkPhase = ''
    ${python.interpreter} -m numba.runtests
  '';

  # ImportError: cannot import name '_typeconv'
  doCheck = false;

  pythonImportsCheck = [
    "numba"
  ];

  meta =  with lib; {
    description = "Compiling Python code using LLVM";
    homepage = "https://numba.pydata.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fridh ];
  };
}
