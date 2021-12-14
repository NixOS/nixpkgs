{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, cocotb-bus
, pytestCheckHook
, swig
, verilog
}:

buildPythonPackage rec {
  pname = "cocotb";
  version = "1.6.0";

  # - we need to use the tarball from PyPi
  #   or the full git checkout (with .git)
  # - using fetchFromGitHub will cause a build failure,
  #   because it does not include required metadata
  src = fetchPypi {
    inherit pname version;
    sha256 = "a695544ab314e6d795b72ece9e67b51c6668c569b21303158e00452db43c5756";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ setuptools ];

  postPatch = ''
    patchShebangs bin/*.py

    # POSIX portability (TODO: upstream this)
    for f in \
      cocotb/share/makefiles/Makefile.* \
      cocotb/share/makefiles/simulators/Makefile.*
    do
      substituteInPlace $f --replace 'shell which' 'shell command -v'
    done

    # remove circular dependency cocotb-bus from setup.py
    substituteInPlace setup.py --replace "'cocotb-bus<1.0'" ""
  '';

  checkInputs = [ cocotb-bus pytestCheckHook swig verilog ];

  checkPhase = ''
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    description = "Coroutine based cosimulation library for writing VHDL and Verilog testbenches in Python";
    homepage = "https://github.com/cocotb/cocotb";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthuszagh ];
    broken = stdenv.isDarwin;
  };
}
