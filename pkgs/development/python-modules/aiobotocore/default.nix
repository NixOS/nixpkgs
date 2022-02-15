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
  version = "2.1.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2+mrmXhRwkWLB6hfaCvizPNdZ51d4Pj1cSKfdArXunE=";
  };

  # relax version constraints: aiobotocore works with newer botocore versions
  # the pinning used to match some `extras_require` we're not using.
  postPatch = ''
    sed -i "s/'botocore>=.*'/'botocore'/" setup.py
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
