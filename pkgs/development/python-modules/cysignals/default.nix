{ lib
, fetchPypi
, buildPythonPackage
, cython
, sphinx
}:

buildPythonPackage rec {
  pname = "cysignals";
  version = "1.6.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "003invnixqy1h4lb358vwrxykxzp15csaddkgq3pqqmswnva5908";
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
