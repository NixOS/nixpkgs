{ lib
, fetchurl
, buildPythonPackage
, pytestrunner
, pythonOlder
}:

let
  pname = "async-timeout";
  version = "1.1.0";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "b88bd1fe001b800ec23c7bf27a81b32819e2a56668e9fba5646a7f3618143081";
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