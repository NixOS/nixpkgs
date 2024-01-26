{ lib, buildPythonPackage, fetchPypi, autoPatchelfHook }:

buildPythonPackage rec {
  pname = "pypemicro";
  version = "0.1.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KE085u9yIPsuEr41GNWwHFm6KAHggvqGqP9ChGRoLE0=";
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
