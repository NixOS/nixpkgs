{ lib
, fetchPypi
, buildPythonPackage
, cython
, sphinx
}:

buildPythonPackage rec {
  pname = "cysignals";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15nky8siwlc7s8v23vv4m0mnxa1z6jcs2qfr26m2mkw9j9g2na2j";
  };

  hardeningDisable = [
    "fortify"
  ];

  # currently fails, probably because of formatting changes in gdb 8.0
  doCheck = false;

  preCheck = ''
    # Make sure cysignals-CSI is in PATH
    export PATH="$out/bin:$PATH"
  '';

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
