{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  numpy,
  packaging,
  pandas,
  pyarrow,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "db-dtypes";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "db-dtypes-v${finalAttrs.version}";
    hash = "sha256-KJviH4dofYSvZu9S7VMBSnGjH66xMUEvhcmZN7GJ4Iw=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/db-dtypes";

  patches = [
    (fetchpatch {
      name = "support-pandas-3.0.patch";
      url = "https://github.com/googleapis/google-cloud-python/commit/2086b34d8b3418462c9bc89b96eac779a25a3afd.patch";
      relative = "packages/db-dtypes";
      hash = "sha256-0NvbTCnr95IW7rkQVu3iUDsNXU/LzXhJwwSDdliFZ+Y=";
    })
  ];

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
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${finalAttrs.src.tag}/packages/db-dtypes/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
