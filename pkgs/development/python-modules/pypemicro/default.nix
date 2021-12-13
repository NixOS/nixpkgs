{ lib, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  version = "0.1.7";
  pname = "pypemicro";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-G2RXDhXy7IGcrEMVQrsT14nb2KhC5QQrmF4lhe1iDgU=";
  };
  meta = {
    description = "A Python interface for PEMicro debug probes";
    longDescription = ''
      This is simple package that provides Python interface for PEMicro
      debug probes precompiled libraries. The package provides most of
      functionality of the PEMicro libraries and their debug probes.

      The package is tested only with Multilink/FX and Cyclone/FX probes
      on NXP ARM microcontrollers.
    '';
    homepage = "https://github.com/nxpmicro/pypemicro";
    license = [ lib.licenses.bsd3 ];
    maintainers = [ lib.maintainers.theotherjimmy ];
  };
}
