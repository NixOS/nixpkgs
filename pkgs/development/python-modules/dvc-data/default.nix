{
  lib,
  buildPythonPackage,
  dictdiffer,
  diskcache,
  dvc-objects,
  fetchFromGitHub,
  funcy,
  pygtrie,
  pythonOlder,
  setuptools-scm,
  shortuuid,
  sqltrie,
}:

buildPythonPackage rec {
  pname = "dvc-data";
  version = "3.16.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-data";
    rev = "refs/tags/${version}";
    hash = "sha256-QTsKjF7aVUUFi/6WtuLDVaKOOEzkbkQKpT9L2Mg6724=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    dictdiffer
    diskcache
    dvc-objects
    funcy
    pygtrie
    shortuuid
    sqltrie
  ];

  # Tests depend on upath which is unmaintained and only available as wheel
  doCheck = false;

  pythonImportsCheck = [ "dvc_data" ];

  meta = with lib; {
    description = "DVC's data management subsystem";
    mainProgram = "dvc-data";
    homepage = "https://github.com/iterative/dvc-data";
    changelog = "https://github.com/iterative/dvc-data/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
