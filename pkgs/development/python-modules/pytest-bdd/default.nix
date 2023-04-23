{ lib
, buildPythonPackage
, fetchFromGitHub
, mako
, parse
, parse-type
, poetry-core
, pytest
, pytestCheckHook
, pythonOlder
, setuptools
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pytest-bdd";
  version = "6.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-+76jIgfDQPdIoesTr1+QUu8wmOnrdf4KT+TJr9F2Hqk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    mako
    parse
    parse-type
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    setuptools
  ];

  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  pythonImportsCheck = [
    "pytest_bdd"
  ];

  meta = with lib; {
    description = "BDD library for the pytest";
    homepage = "https://github.com/pytest-dev/pytest-bdd";
    license = licenses.mit;
    maintainers = with maintainers; [ jm2dev ];
  };
}
