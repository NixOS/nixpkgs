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
  version = "2.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XI7nnR8UJz4/jzr1yJPbiJ7xYyJ7F47Ky1rqRUfTuac=";
  };

  # Relax version constraints: aiobotocore works with newer botocore versions
  # the pinning used to match some `extras_require` we're not using.
  postPatch = ''
    sed -i "s/'botocore>=.*'/'botocore'/" setup.py
  '';

  propagatedBuildInputs = [
    wrapt
    aiohttp
    aioitertools
    botocore
  ];

  # Tests not distributed on PyPI
  doCheck = false;

  pythonImportsCheck = [
    "aiobotocore"
  ];

  meta = with lib; {
    description = "Python client for amazon services";
    homepage = "https://github.com/aio-libs/aiobotocore";
    changelog = "https://github.com/aio-libs/aiobotocore/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teh ];
  };
}
