{ buildPythonPackage 
, fetchurl
, fetchFromGitHub
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
, pythonOlder
, isPy35
}:
let
  compyte = import ./compyte.nix {
    inherit mkDerivation fetchFromGitHub;
  };
in
buildPythonPackage rec {
  pname = "pycuda";
  version = "2016.1.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "0dvf1cnrlvmrc7i100n2ndrnd7fjm7aq3wpmk2nx5h7hwb3xmnx7";
  };

  preConfigure = ''
    findInputs ${boost.dev} boost_dirs propagated-native-build-inputs

    export BOOST_INCLUDEDIR=$(echo $boost_dirs | sed -e s/\ /\\n/g - | grep '\-dev')/include
    export BOOST_LIBRARYDIR=$(echo $boost_dirs | sed -e s/\ /\\n/g - | grep -v '\-dev')/lib

    ${python.interpreter} configure.py --boost-inc-dir=$BOOST_INCLUDEDIR \
                            --boost-lib-dir=$BOOST_LIBRARYDIR \
                            --no-use-shipped-boost \
                            --boost-python-libname=boost_python
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
  ]; 

  meta = with stdenv.lib; {
    homepage = https://github.com/inducer/pycuda/;
    description = "CUDA integration for Python.";
    license = licenses.mit;
    maintainers = with maintainers; [ artuuge ];
  };

}
