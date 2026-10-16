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
  appdirs,
  six,
  cudaPackages,
  python,
  mkDerivation,
  lib,
  symlinkJoin,
}:
let
  compyte = import ./compyte.nix { inherit mkDerivation fetchFromGitHub; };

  cudaRoot = symlinkJoin {
    name = "pycuda-cuda-root";
    paths = with cudaPackages; [
      cuda_cudart
      cuda_nvcc
      (lib.getInclude cuda_profiler_api)
      (lib.getInclude libcurand)
      (lib.getLib libcurand)
    ];
  };
in
buildPythonPackage rec {
  pname = "pycuda";
  version = "2026.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dZUWFgYougbzLOflY+P1uSFGkdyVKKA+qZ6hBz9OFLo=";
  };

  preConfigure = with lib.versions; ''
    ${python.pythonOnBuildForHost.interpreter} configure.py --boost-inc-dir=${boost.dev}/include \
                          --boost-lib-dir=${boost}/lib \
                          --no-use-shipped-boost \
                          --boost-python-libname=boost_python${major python.version}${minor python.version} \
                          --cuda-root=${cudaRoot}
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

  propagatedBuildInputs = [
    numpy
    pytools
    pytest
    decorator
    appdirs
    six
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvcc
    (lib.getInclude cudaPackages.cuda_profiler_api)
    cudaPackages.libcurand
    compyte
    python
    mako
  ];

  meta = {
    homepage = "https://github.com/inducer/pycuda/";
    description = "CUDA integration for Python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
