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
, isPy3k
}:
let
  compyte = import ./compyte.nix {
    inherit mkDerivation fetchFromGitHub;
  };
in
buildPythonPackage rec {
  pname = "pycuda";
  version = "2017.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qxmcjax32p1ywicw9sha2rvfbak4kjbx9pq57j3wq4cwf296nkb";
  };

  preConfigure = ''
    ${python.interpreter} configure.py --boost-inc-dir=${boost.dev}/include \
                          --boost-lib-dir=${boost}/lib \
                          --no-use-shipped-boost \
                          --boost-python-libname=boost_python${stdenv.lib.optionalString isPy3k "3"}
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
    homepage = https://github.com/inducer/pycuda/;
    description = "CUDA integration for Python.";
    license = licenses.mit;
    maintainers = with maintainers; [ artuuge ];
  };

}
