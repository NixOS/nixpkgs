{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  setuptools,
  tox
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "7.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nedbat";
    repo = "coveragepy";
    tag = version;
    hash = "sha256-clnwx9Fa75aLfGe/MZVtIzE8Ah5EY7MQf8g11TSkl/c=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    mock
    tox
  ];

  pythonImportsCheck = [ "coverage" ];

  meta = {
    description = "Code coverage measurement for python";
    homepage = "https://coverage.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ osbm ];
  };
}
