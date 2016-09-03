{ buildPythonPackage 
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
}:
let
  compyte = import ./compyte.nix {
    inherit mkDerivation fetchFromGitHub;
  };
in
buildPythonPackage rec {
  name = "pycuda-${version}"; 
  version = "2016.1"; 

  src = fetchFromGitHub {
    owner = "inducer"; 
    repo = "pycuda";
    rev = "609817e22c038249f5e9ddd720b3ca5a9d58ca11"; 
    sha256 = "0kg6ayxsw2gja9rqspy6z8ihacf9jnxr8hzywjwmj1izkv24cff7"; 
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

  doCheck = pythonOlder "3.5";

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
