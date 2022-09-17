{ lib, buildPythonPackage, fetchPypi, autoPatchelfHook }:

buildPythonPackage rec {
  pname = "pypemicro";
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HouDBlqfokKhbdWWDCfaUJrqIEC5f+sSnVmsrRseFmU=";
  };

  pythonImportsCheck = [ "pypemicro" ];

  # tests are neither pytest nor unittest compatible and require a device
  # connected via USB
  doCheck = false;

  meta = with lib; {
    description = "Python interface for PEMicro debug probes";
    homepage = "https://github.com/NXPmicro/pypemicro";
    license = with licenses; [ bsd3 unfree ]; # it includes shared libraries for which no license is available (https://github.com/NXPmicro/pypemicro/issues/10)
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}
