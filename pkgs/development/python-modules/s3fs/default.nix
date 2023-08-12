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
  version = "2023.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y/2N3wXrci3nhLe1AxlhB/KlGAYSmM8AWopHFbTUkRc=";
  };

  postPatch = ''
    sed -i 's/fsspec==.*/fsspec/' requirements.txt
  '';

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
    description = "A Pythonic file interface for S3";
    homepage = "https://github.com/fsspec/s3fs";
    changelog = "https://github.com/fsspec/s3fs/raw/${version}/docs/source/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
