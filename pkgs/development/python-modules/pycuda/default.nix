{ buildPythonPackage
, addOpenGLRunpath
, fetchPypi
, fetchFromGitHub
, mako
, boost
, numpy
, pytools
, pytest
, decorator
, appdirs
, six
, cudaPackages
, python
, mkDerivation
, lib
}:
let
  compyte = import ./compyte.nix {
    inherit mkDerivation fetchFromGitHub;
  };

  inherit (cudaPackages) cudatoolkit;
in
buildPythonPackage rec {
  pname = "pycuda";
  version = "2023.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F1/2dfDPEOOOmtwD7V3z7Y2Kv32lE0yNzOx1LooKPpE=";
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
      addOpenGLRunpath "$lib"
    done
  '';

  # Requires access to libcuda.so.1 which is provided by the driver
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  nativeBuildInputs = [
    addOpenGLRunpath
  ];

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
    description = "CUDA integration for Python.";
    license = licenses.mit;
    maintainers = with maintainers; [ artuuge ];
  };

}
