{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, cocotb-bus
, pytest
, swig
, verilog
}:

buildPythonPackage rec {
  pname = "cocotb";
  version = "1.5.2";

  # - we need to use the tarball from PyPi
  #   or the full git checkout (with .git)
  # - using fetchFromGitHub will cause a build failure,
  #   because it does not include required metadata
  src = fetchPypi {
    inherit pname version;
    sha256 = "9f4f3e6eb9caeb479e98d604770645b57469cd25b39e28df1916ffcd593efbe6";
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

  checkInputs = [ cocotb-bus pytest swig verilog ];

  checkPhase = ''
    export PATH=$out/bin:$PATH
    make test
  '';

  meta = with lib; {
    description = "Coroutine based cosimulation library for writing VHDL and Verilog testbenches in Python";
    homepage = "https://github.com/cocotb/cocotb";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthuszagh ];
    broken = stdenv.isDarwin;
  };
}
