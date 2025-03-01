{
  lib,
  beancount,
  click,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  pytestCheckHook,
  setuptools,
  tatsu-lts,
}:
buildPythonPackage {
  pname = "beanquery";
  version = "0.1.0-unstable-2025-01-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "beanquery";
    # Pinned at commit where tatsu dependency replaced with tatsu-lts
    # Later snapsot versions break fava build due to API changes at beanquery/shell.py
    rev = "e77a67996a54eef2e9d77b6352c74a40164e281d";
    hash = "sha256-XYfKAscm55lY4YjIGTQ6RMFnCPWemfszpheGQ9qjMiM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beancount
    click
    python-dateutil
    tatsu-lts
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
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
