{ lib
, boto3
, botocore
, buildPythonPackage
<<<<<<< HEAD
, fastparquet
, fetchPypi
, fsspec
, pandas
, poetry-core
, pyarrow
, pythonOlder
, sqlalchemy
=======
, fetchPypi
, fsspec
, pandas
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, tenacity
}:

buildPythonPackage rec {
  pname = "pyathena";
<<<<<<< HEAD
  version = "3.0.6";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7m6hdRNIlCCa8sa+GFm3vkNx93QfqnpY+fl5Bf9qc6Q=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

=======
  version = "2.23.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6T2qr0fcHzgDPZvc3StZwIH2ZRvTOJFXDLPc3iFmwCQ=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    boto3
    botocore
    fsspec
<<<<<<< HEAD
    tenacity
  ];

  passthru.optional-dependencies = {
    pandas = [
      pandas
    ];
    sqlalchemy = [
      sqlalchemy
    ];
    arrow = [
      pyarrow
    ];
    fastparquet = [
      fastparquet
    ];
  };

=======
    pandas
    tenacity
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Nearly all tests depend on a working AWS Athena instance,
  # therefore deactivating them.
  # https://github.com/laughingman7743/PyAthena/#testing
  doCheck = false;

  pythonImportsCheck = [
    "pyathena"
  ];

  meta = with lib; {
    description = "Python DB API 2.0 (PEP 249) client for Amazon Athena";
    homepage = "https://github.com/laughingman7743/PyAthena/";
<<<<<<< HEAD
    changelog = "https://github.com/laughingman7743/PyAthena/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ turion ];
  };
}
