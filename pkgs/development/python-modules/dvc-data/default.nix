{
  lib,
  attrs,
  buildPythonPackage,
  dictdiffer,
  diskcache,
  dvc-objects,
  fetchFromGitHub,
  fsspec,
  orjson,
  pygtrie,
  pythonOlder,
  setuptools-scm,
  sqltrie,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "dvc-data";
  version = "3.18.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-data";
    tag = finalAttrs.version;
    hash = "sha256-3Zct/cOSxf8UYT4Kss4krWERrBatd5R3mcpDivsCIac=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    attrs
    dictdiffer
    diskcache
    dvc-objects
    fsspec
    orjson
    pygtrie
    sqltrie
    tqdm
  ];

  # Tests depend on upath which is unmaintained and only available as wheel
  doCheck = false;

  pythonImportsCheck = [ "dvc_data" ];

  meta = {
    description = "DVC's data management subsystem";
    homepage = "https://github.com/iterative/dvc-data";
    changelog = "https://github.com/iterative/dvc-data/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dvc-data";
  };
})
