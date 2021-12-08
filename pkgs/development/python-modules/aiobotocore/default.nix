{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, wrapt
, aioitertools
, aiohttp
, botocore
}:

buildPythonPackage rec {
  pname = "aiobotocore";
  version = "1.4.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
     owner = "aio-libs";
     repo = "aiobotocore";
     rev = "1.4.2";
     sha256 = "11wvcsxpzbfz4iwvr35lvpf5padfnkfydrnr9m9m9virila8npgl";
  };

  # relax version constraints: aiobotocore works with newer botocore versions
  # the pinning used to match some `extras_require` we're not using.
  postPatch = ''
    substituteInPlace setup.py --replace 'botocore>=1.20.106,<1.20.107' 'botocore'
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
