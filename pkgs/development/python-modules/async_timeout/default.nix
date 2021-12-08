{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "async-timeout";
  version = "4.0.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
     owner = "aio-libs";
     repo = "async_timeout";
     rev = "v4.0.1";
     sha256 = "0jgpd5qs9flg7gz56a48bx6m365mf0ldim8aa2xpcqnsxq81zxyp";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  # Circular dependency on aiohttp
  doCheck = false;

  meta = {
    description = "Timeout context manager for asyncio programs";
    homepage = "https://github.com/aio-libs/async_timeout/";
    license = lib.licenses.asl20;
  };
}
