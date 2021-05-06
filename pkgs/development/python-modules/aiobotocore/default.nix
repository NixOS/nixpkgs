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
  version = "1.3.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17pcdi69bwdfw2wv3a0fhira5gimw88sp2wf47yqz50z1ckhv2c1";
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
