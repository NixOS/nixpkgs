{ lib
, buildPythonPackage
, fetchFromGitHub
, stevedore
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "plux";
  version = "1.3.1";
  format = "pyproject";

  # Tests are not available from PyPi
  src = fetchFromGitHub {
    owner = "localstack";
    repo = "plux";
    # Request for proper tags: https://github.com/localstack/plux/issues/4
    rev = "a412ab0a0d7d17c3b5e1f560b7b31dc1876598f7";
    sha256 = "sha256-zFwrRc93R4cXah7zYXjVLBIeBpDedsInxuyXOyBI8SA=";
  };

  propagatedBuildInputs = [
    stevedore
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "plugin.core" ];

  meta = with lib; {
    description = "Dynamic code loading framework for building pluggable Python distributions";
    homepage = "https://github.com/localstack/plux";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
