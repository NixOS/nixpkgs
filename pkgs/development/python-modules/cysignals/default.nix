{ lib
, fetchPypi
, buildPythonPackage
, cython
, pariSupport ? true, pari # for interfacing with the PARI/GP signal handler
}:

assert pariSupport -> pari != null;

buildPythonPackage rec {
  pname = "cysignals";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yh4lyrinhxxra42p0k4hiyjdrqjmifg4gnmf4bky5wa0mqnyai6";
  };

  # explicit check:
  # build/src/cysignals/implementation.c:27:2: error: #error "cysignals must be compiled without _FORTIFY_SOURCE"
  hardeningDisable = [
    "fortify"
  ];

  # currently fails, probably because of formatting changes in gdb 8.0
  # https://trac.sagemath.org/ticket/24692
  doCheck = false;

  preCheck = ''
    # Make sure cysignals-CSI is in PATH
    export PATH="$out/bin:$PATH"
  '';

  buildInputs = lib.optionals pariSupport [
    pari
  ];

  propagatedBuildInputs = [
    cython
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Interrupt and signal handling for Cython";
    homepage = https://github.com/sagemath/cysignals/;
    maintainers = with lib.maintainers; [ timokau ];
    license = lib.licenses.lgpl3Plus;
  };
}
