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

buildPythonPackage rec {
  pname = "dvc-data";
  version = "3.16.11";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-data";
    tag = version;
    hash = "sha256-BuGJzIZzHr/Q7N+bO3WUb92I6fs3tWxb/xdf22vFbj8=";
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

  meta = with lib; {
    description = "DVC's data management subsystem";
    homepage = "https://github.com/iterative/dvc-data";
    changelog = "https://github.com/iterative/dvc-data/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "dvc-data";
  };
}
