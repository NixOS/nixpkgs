{
  buildPythonPackage,
  addDriverRunpath,
  fetchPypi,
  fetchFromGitHub,
  mako,
  boost,
  numpy,
  pytools,
  pytest,
  decorator,
  platformdirs,
  six,
  cudaPackages,
  python,
  mkDerivation,
  lib,
  stdenvNoCC,
}:
let
  compyte = import ./compyte.nix { inherit mkDerivation fetchFromGitHub; };

  inherit (cudaPackages)
    cuda_cudart
    cuda_nvcc
    cuda_profiler_api
    libcurand
    ;
  # PyCUDA invokes NVCC after installation, to compile code for the machine
  # running Python. This is independent of the compiler used to build PyCUDA.
  jitCompiler = cuda_nvcc.__spliced.hostHost or cuda_nvcc;
in
buildPythonPackage (finalAttrs: {
  pname = "pycuda";
  version = "2026.1";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-dZUWFgYougbzLOflY+P1uSFGkdyVKKA+qZ6hBz9OFLo=";
  };

  patches = [
    ./runtime-compiler.patch
    ./managed-memory-defaults.patch
    ./curand-buffer-validation.patch
  ];
  postPatch = ''
    substituteInPlace pycuda/compiler.py \
      --replace-fail 'nvcc="nvcc"' 'nvcc="${lib.getExe' (lib.getOutput jitCompiler.outputBin jitCompiler) "nvcc"}"' \
      --replace-fail 'include_dirs = [*include_dirs, _find_pycuda_include_path()]' \
        'include_dirs = [*include_dirs, _find_pycuda_include_path(), "${lib.getOutput libcurand.outputInclude libcurand}/include"]' \
      --replace-fail '@cudaLibraryDir@' '${lib.getOutput cuda_cudart.outputStatic cuda_cudart}/lib'
  '';

  preConfigure = with lib.versions; ''
    ${python.pythonOnBuildForHost.interpreter} configure.py --boost-inc-dir=${boost.dev}/include \
                          --boost-lib-dir=${boost}/lib \
                          --no-use-shipped-boost \
                          --boost-python-libname=boost_python${major python.version}${minor python.version} \
                          --cuda-root=${cuda_cudart}
  '';

  postInstall = ''
    ln -s ${compyte} $out/${python.sitePackages}/pycuda/compyte
  '';

  postFixup = ''
    find $out/lib -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      echo "setting opengl runpath for $lib..."
      addDriverRunpath "$lib"
    done
  '';

  # Requires access to libcuda.so.1 which is provided by the driver
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  nativeBuildInputs = [ addDriverRunpath ];

  buildInputs = [
    cuda_profiler_api
    libcurand
  ];

  propagatedBuildInputs = [
    numpy
    pytools
    pytest
    decorator
    platformdirs
    six
    cuda_cudart
    compyte
    python
    mako
  ];

  passthru.tests = lib.optionalAttrs (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) {
    curandBuffers = python.pkgs.callPackage ./curand-buffer-test.nix {
      pycuda = finalAttrs.finalPackage;
      inherit cudaPackages;
    };
    jit = python.pkgs.callPackage ./jit-test.nix {
      pycuda = finalAttrs.finalPackage;
      inherit cudaPackages;
    };
  };

  meta = {
    homepage = "https://github.com/inducer/pycuda/";
    description = "CUDA integration for Python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
