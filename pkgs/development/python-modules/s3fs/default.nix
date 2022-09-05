{ lib
, stdenv
, aiobotocore
, aiohttp
, buildPythonPackage
, docutils
, fetchPypi
, fsspec
, pythonOlder
}:

buildPythonPackage rec {
  pname = "s3fs";
  version = "2022.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tAo8v6+Ay6uvDjMjMRF8ysaSkO/aw0cYT7OrYAP3BGU=";
  };

  buildInputs = [
    docutils
  ];

  propagatedBuildInputs = [
    aiobotocore
    aiohttp
    fsspec
  ];

  # Depends on `moto` which has a long dependency chain with exact
  # version requirements that can't be made to work with current
  # pythonPackages.
  doCheck = false;

  pythonImportsCheck = [
    "s3fs"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/dask/s3fs/";
    description = "A Pythonic file interface for S3";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
