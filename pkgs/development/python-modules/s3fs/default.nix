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
<<<<<<< HEAD
  version = "2023.9.0";
=======
  version = "2023.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-NQV9TVlyLKuf6RyaMBR+Plvd/FXsFP3od2xRIXnII90=";
=======
    hash = "sha256-XBVN7Tjjw9jw66f+wnBvKbQeDDlfGfv+87qOcMaFsEk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
