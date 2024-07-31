{ lib
, beancount
, click
, buildPythonPackage
, fetchFromGitHub
, python-dateutil
, pytestCheckHook
, setuptools
, tatsu
}:
buildPythonPackage rec {
  pname = "beanquery";
  version = "0.1.dev1-2024-06-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "beanquery";
    rev = "7577b6c1b93cfdecd76e9c5f466e0ab96bddd045";
    hash = "sha256-xFhlkFlD+VG0n6WfKLjuhm7Cwz3t2V6GxmMXc5TgIPc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    beancount
    click
    python-dateutil
    tatsu
  ];

  pythonRelaxDeps = [
    "tatsu"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "beancount"
    "beanquery"
  ];

  meta = with lib; {
    homepage = "https://github.com/beancount/beanquery";
    description = "Beancount Query Language";
    longDescription = ''
      A customizable light-weight SQL query tool that works on tabular data,
      including Beancount.
    '';
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ alapshin ];
    mainProgram = "bean-query";
  };
}
