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
  version = "0.3.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "852a493a877b73e11823bfd4e8e5ef2610d70d12c9eaed961bcd9124d8de8c10";
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
