{ stdenv, buildPythonPackage, fetchFromGitHub, setuptools, swig, verilog }:

buildPythonPackage rec {
  pname = "cocotb";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0akkxcj11543c0jn4zdw4a668lk0xg7pghs8mch3xjk8nn8wfblc";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  postPatch = ''
    patchShebangs bin/*.py

    # POSIX portability (TODO: upstream this)
    for f in \
      cocotb/share/makefiles/Makefile.* \
      cocotb/share/makefiles/simulators/Makefile.*
    do
      substituteInPlace $f --replace 'shell which' 'shell command -v'
    done

    # This can perhaps be removed in the next update after 1.3.2?
    substituteInPlace cocotb/share/makefiles/Makefile.inc --replace "-Werror" ""
  '';

  checkInputs = [ swig verilog ];

  checkPhase = ''
    # test expected failures actually pass because of a fix in our icarus version
    # https://github.com/cocotb/cocotb/issues/1952
    substituteInPlace tests/test_cases/test_discovery/test_discovery.py \
      --replace 'def access_single_bit' $'def foo(x): pass\ndef foo' \
      --replace 'def access_single_bit_assignment' $'def foo(x): pass\ndef foo'

    export PATH=$out/bin:$PATH
    make test
  '';

  meta = with stdenv.lib; {
    description = "Coroutine based cosimulation library for writing VHDL and Verilog testbenches in Python";
    homepage = "https://github.com/cocotb/cocotb";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
