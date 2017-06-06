{ lib
, buildPythonPackage
, fetchPypi
, isPy33
, pythonOlder
, asyncio
, singledispatch
}:

buildPythonPackage rec {
  pname = "aiofiles";
  version = "0.3.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c4936cea65175277183553dbc27d08b286a24ae5bd86f44fbe485dfcf77a14a";
  };

  disabled = pythonOlder "3.3";

  propagatedBuildInputs = lib.optionals isPy33 [ asyncio singledispatch ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "File support for asyncio";
    homepage = https://github.com/Tinche/aiofiles;
    license = with lib.licenses; [ asl20 ];
    maintainer = with lib.maintainers; [ fridh ];
  };
}