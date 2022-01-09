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
  version = "1.6.1";

  # - we need to use the tarball from PyPi
  #   or the full git checkout (with .git)
  # - using fetchFromGitHub will cause a build failure,
  #   because it does not include required metadata
  src = fetchPypi {
    inherit pname version;
    sha256 = "b644a15ea1e62c55041176468976541cba30a8a5e99a5e9a2c07ee595c2b4e95";
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
