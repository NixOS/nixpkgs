{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestrunner
, typing-extensions
, wrapt
, aioitertools
, aiohttp
, botocore
}:

buildPythonPackage rec {
  pname = "aiobotocore";
  version = "1.1.2";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fn9hgcg3qr9f7srjxc21bzkiix4al9308531slwlm99r0x3xcjl";
  };

  # relax version constraints: aiobotocore works with newer botocore versions
  # the pinning used to match some `extras_require` we're not using.
  preConfigure = ''
    substituteInPlace setup.py --replace 'botocore>=1.17.44,<1.17.45' 'botocore'
  '';

  propagatedBuildInputs = [ wrapt aiohttp aioitertools botocore ];

  # tests not distributed on pypi
  doCheck = false;
  pythonImportsCheck = [ "aiobotocore" ];

  meta = with lib; {
    description = "Async client for amazon services using botocore and aiohttp/asyncio.";
    license = licenses.asl20;
    homepage = "https://github.com/aio-libs/aiobotocore";
    maintainers = with maintainers; [ teh ];
  };
}
