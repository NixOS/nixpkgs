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
}:
let
  compyte = import ./compyte.nix { inherit mkDerivation fetchFromGitHub; };

  inherit (cudaPackages) cudatoolkit;
in
buildPythonPackage rec {
  pname = "pycuda";
  version = "2024.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0RC3J8vqhZ2ktj6Rtvoen8MsW63gLYn/RJl1mW6cz6s=";
  };

  preConfigure = with lib.versions; ''
    ${python.pythonOnBuildForHost.interpreter} configure.py --boost-inc-dir=${boost.dev}/include \
                          --boost-lib-dir=${boost}/lib \
                          --no-use-shipped-boost \
                          --boost-python-libname=boost_python${major python.version}${minor python.version} \
                          --cuda-root=${cudatoolkit}
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
    cudatoolkit
    compyte
    python
    mako
  ];

  meta = with lib; {
    homepage = "https://github.com/inducer/pycuda/";
    description = "CUDA integration for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ artuuge ];
  };
}
