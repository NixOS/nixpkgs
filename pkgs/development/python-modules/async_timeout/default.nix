{ lib
, fetchurl
, buildPythonPackage
, pytestrunner
, pythonOlder
}:

let
  pname = "async-timeout";
  version = "1.3.0";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "f4651f122a9877049930ce31a8422bc202a47937627295fe5e411b2c2083481f";
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