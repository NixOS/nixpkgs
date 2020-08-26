{ buildPythonPackage
, fetchPypi
, fetchFromGitHub
, Mako
, boost
, numpy
, pytools
, pytest
, decorator
, appdirs
, six
, cudatoolkit
, python
, mkDerivation
, stdenv
}:
let
  compyte = import ./compyte.nix {
    inherit mkDerivation fetchFromGitHub;
  };
in
buildPythonPackage rec {
  pname = "pycuda";
  version = "2019.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ada56ce98a41f9f95fe18809f38afbae473a5c62d346cfa126a2d5477f24cc8a";
  };

  preConfigure = with stdenv.lib.versions; ''
    ${python.interpreter} configure.py --boost-inc-dir=${boost.dev}/include \
                          --boost-lib-dir=${boost}/lib \
                          --no-use-shipped-boost \
                          --boost-python-libname=boost_python${major python.version}${minor python.version} \
                          --cuda-root=${cudatoolkit}
  '';

  postInstall = ''
    ln -s ${compyte} $out/${python.sitePackages}/pycuda/compyte
  '';

  # Requires access to libcuda.so.1 which is provided by the driver
  doCheck = false;

  checkPhase = ''
    py.test
  '';

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
    Mako
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/inducer/pycuda/";
    description = "CUDA integration for Python.";
    license = licenses.mit;
    maintainers = with maintainers; [ artuuge ];
  };

}
