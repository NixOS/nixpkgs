{ stdenv, buildPythonPackage, fetchFromGitHub, setuptools, swig, verilog }:

buildPythonPackage rec {
  pname = "cocotb";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "118wp5sjsl99hj8pqw5n3v2lry9r949p2hv4l92p086q1n0axxk3";
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

    # This can probably be removed in the next update after 1.3.1
    substituteInPlace cocotb/share/makefiles/Makefile.inc --replace "-Werror" ""
  '';

  checkInputs = [ swig verilog ];

  checkPhase = ''
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
