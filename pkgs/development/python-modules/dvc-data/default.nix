{ lib
, buildPythonPackage
, dictdiffer
, diskcache
, dvc-objects
, fetchFromGitHub
, funcy
, pygtrie
, pythonOlder
, setuptools-scm
, shortuuid
, sqltrie
}:

buildPythonPackage rec {
  pname = "dvc-data";
  version = "3.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-data";
    rev = "refs/tags/${version}";
    hash = "sha256-ycC6NWvU00yUEHu62H5VLKDEZEHyIo4+TBwj5XaswII=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "dvc_data"
  ];

  meta = with lib; {
    description = "DVC's data management subsystem";
    homepage = "https://github.com/iterative/dvc-data";
    changelog = "https://github.com/iterative/dvc-data/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
