{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "aioprocessing";
  version = "1.1.0";
  disabled = !(pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "4603c86ff3fea673d4c643ad3adc519988cd778771b75079bc3be9e5ed4c5b66";
  };

  # Tests aren't included in pypi package
  doCheck = false;

  meta = {
    description = "A library that integrates the multiprocessing module with asyncio";
    homepage = "https://github.com/dano/aioprocessing";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ uskudnik ];
  };
}
