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
  version = "3.16.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-data";
    tag = version;
    hash = "sha256-lm8GU3Mu+i+9uop5Wdam0kGDzXCeAhzq4/P5WcWj/oQ=";
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
