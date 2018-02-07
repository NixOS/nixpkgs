{ lib
, fetchurl
, buildPythonPackage
, pytestrunner
, pythonOlder
}:

let
  pname = "async-timeout";
  version = "2.0.0";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "c17d8ac2d735d59aa62737d76f2787a6c938f5a944ecf768a8c0ab70b0dea566";
  };

  buildInputs = [ pytestrunner ];
  # Circular dependency on aiohttp
  doCheck = false;

  disabled = pythonOlder "3.4";

  meta = {
    description = "Timeout context manager for asyncio programs";
    homepage = https://github.com/aio-libs/async_timeout/;
    license = lib.licenses.asl20;
  };
}