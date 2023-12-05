{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, numpy
, packaging
, pandas
, pyarrow
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "db-dtypes";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-db-dtypes-pandas";
    rev = "refs/tags/v${version}";
    hash = "sha256-OAVHx/a4uupVGXSWN2/3uem9/4i+TUkzTX4kp0uLY44=";
  };

  patches = [
    # on master branch, to be released as 1.1.2
    (fetchpatch {
      name = "xfail-tests-that-are-known-to-fail.patch";
      url = "https://github.com/googleapis/python-db-dtypes-pandas/commit/4a56b766b0ccba900a555167863f1081a76c4c0d.patch";
      hash = "sha256-ra1d8Vewvwhkr7PBHc3KM6IUCWsHxE+B7UP2duTgjew=";
    })
    # on master branch, to be released as 1.1.2
    (fetchpatch {
      name = "add-import-and-object-reference-due-to-upstream-changes.patch";
      url = "https://github.com/googleapis/python-db-dtypes-pandas/commit/8a7b25f3e708df5cd32afcb702fe16130846b165.patch";
      hash = "sha256-JVbhiOIr5gKMSQpIQ+DgIRqq8V5x5ClQhkQzAmIYqEU=";
    })
  ];

  propagatedBuildInputs = [
    numpy
    packaging
    pandas
    pyarrow
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "db_dtypes"
  ];

  meta = with lib; {
    description = "Pandas Data Types for SQL systems (BigQuery, Spanner)";
    homepage = "https://github.com/googleapis/python-db-dtypes-pandas";
    changelog = "https://github.com/googleapis/python-db-dtypes-pandas/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
