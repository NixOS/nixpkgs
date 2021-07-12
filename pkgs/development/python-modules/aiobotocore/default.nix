{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, wrapt
, aioitertools
, aiohttp
, botocore
}:

buildPythonPackage rec {
  pname = "aiobotocore";
  version = "1.3.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ecee55346651e0f4cbda883e3e16cfe11460b8d7adcc08d0017cbb867636ae1";
  };

  # relax version constraints: aiobotocore works with newer botocore versions
  # the pinning used to match some `extras_require` we're not using.
  postPatch = ''
    substituteInPlace setup.py --replace 'botocore>=1.20.49,<1.20.50' 'botocore'
  '';

  propagatedBuildInputs = [ wrapt aiohttp aioitertools botocore ];

  # tests not distributed on pypi
  doCheck = false;
  pythonImportsCheck = [ "aiobotocore" ];

  meta = with lib; {
    description = "Python client for amazon services";
    license = licenses.asl20;
    homepage = "https://github.com/aio-libs/aiobotocore";
    maintainers = with maintainers; [ teh ];
  };
}
