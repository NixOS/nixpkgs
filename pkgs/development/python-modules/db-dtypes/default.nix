{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  packaging,
  pandas,
  pyarrow,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "db-dtypes";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "db-dtypes-v${version}";
    hash = "sha256-KJviH4dofYSvZu9S7VMBSnGjH66xMUEvhcmZN7GJ4Iw=";
  };

  sourceRoot = "${src.name}/packages/db-dtypes";

  build-system = [ setuptools ];

  dependencies = [
    numpy
    packaging
    pandas
    pyarrow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "db_dtypes" ];

  meta = {
    description = "Pandas Data Types for SQL systems (BigQuery, Spanner)";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/db-dtypes";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${src.tag}/packages/db-dtypes/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
