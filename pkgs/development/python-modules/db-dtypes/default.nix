{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  packaging,
  pandas,
  pyarrow,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "db-dtypes";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-db-dtypes-pandas";
    rev = "refs/tags/v${version}";
    hash = "sha256-InotzUk1lEuTD1tAojpEGfFyjrCDoGaa8JMDUdRd+Hw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    packaging
    pandas
    pyarrow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "db_dtypes" ];

  meta = with lib; {
    description = "Pandas Data Types for SQL systems (BigQuery, Spanner)";
    homepage = "https://github.com/googleapis/python-db-dtypes-pandas";
    changelog = "https://github.com/googleapis/python-db-dtypes-pandas/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
