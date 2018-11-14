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
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "021ea0ba314a86027c166ecc4b4c07f2d40fc0f4b3a950d1868a0f2571c2bbee";
  };

  disabled = pythonOlder "3.3";

  propagatedBuildInputs = lib.optionals isPy33 [ asyncio singledispatch ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "File support for asyncio";
    homepage = https://github.com/Tinche/aiofiles;
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
