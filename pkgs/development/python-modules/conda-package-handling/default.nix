{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, conda-package-streaming
, pythonOlder
, pytestCheckHook
, pytest-cov
, pytest-mock
}:

buildPythonPackage rec {

  pname = "conda-package-handling";
  version = "2.2.0";

  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "conda";
    repo = pname;
    rev = version;
    hash = "sha256-WeGfmT6lLwcwhheLBPMFcVMudY+zPsvTuXuOsiEAorQ=";
  };

  checkInputs = [
    pytestCheckHook
    pytest-cov
    pytest-mock
  ];

  propagatedBuildInputs = [
    conda-package-streaming
  ];

  pythonImportsCheck = [ "conda_package_handling" ];

  meta = with lib; {
    description = "Create and extract conda packages of various formats";
    homepage = "https://github.com/conda/conda-package-handling";
    license = licenses.bsd3;
    maintainers = with maintainers; [ r-burns ];
    mainProgram = "cph";
  };
}
