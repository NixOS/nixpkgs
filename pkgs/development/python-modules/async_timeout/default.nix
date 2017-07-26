{ lib
, fetchurl
, buildPythonPackage
, pytestrunner
, pythonOlder
}:

let
  pname = "async-timeout";
  version = "1.2.1";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "380e9bfd4c009a14931ffe487499b0906b00b3378bb743542cfd9fbb6d8e4657";
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