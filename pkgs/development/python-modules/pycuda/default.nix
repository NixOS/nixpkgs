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
  version = "2020.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "effa3b99b55af67f3afba9b0d1b64b4a0add4dd6a33bdd6786df1aa4cc8761a5";
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
