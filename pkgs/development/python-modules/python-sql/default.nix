{
  lib,
<<<<<<< HEAD
  fetchFromGitLab,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
=======
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "python-sql";
<<<<<<< HEAD
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "foss.heptapod.net";
    owner = "tryton";
    repo = "python-sql";
    tag = version;
    hash = "sha256-JhMJEng6QftWBmJIC2pYlf9fkHHmSd3k0tSwr35MmVQ=";
  };

  build-system = [ setuptools ];

=======
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "python_sql";
    inherit version;
    hash = "sha256-WzShJOitdMU6zZckhoS1v7tFODiPZnZmKYGjJxg+w2w=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sql" ];

<<<<<<< HEAD
  meta = {
    description = "Library to write SQL queries in a pythonic way";
    homepage = "https://foss.heptapod.net/tryton/python-sql";
    changelog = "https://foss.heptapod.net/tryton/python-sql/-/blob/${src.tag}/CHANGELOG";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ johbo ];
=======
  meta = with lib; {
    description = "Library to write SQL queries in a pythonic way";
    homepage = "https://foss.heptapod.net/tryton/python-sql";
    changelog = "https://foss.heptapod.net/tryton/python-sql/-/blob/${version}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ johbo ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
