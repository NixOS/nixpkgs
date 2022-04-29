{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioprocessing";
  version = "2.0.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "469dfb746e8c4e0c727ba135cfabf9e034c554f6a73c27f908bfe3625dd74b9e";
  };

  # Tests aren't included in pypi package
  doCheck = false;

  pythonImportsCheck = [ "aioprocessing" ];

  meta = {
    description = "A library that integrates the multiprocessing module with asyncio";
    homepage = "https://github.com/dano/aioprocessing";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ uskudnik ];
  };
}
