{
  lib,
  beancount,
  click,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  pytestCheckHook,
  setuptools,
  tatsu,
}:
buildPythonPackage rec {
  pname = "beanquery";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "beanquery";
    rev = "refs/tags/v${version}";
    hash = "sha256-1+KTUvnqPceRbzY1OZwOSQdK7f78K9kSwtQfI1SUIa8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beancount
    click
    python-dateutil
    tatsu
  ];

  pythonRelaxDeps = [ "tatsu" ];

  nativeCheckInputs = [ pytestCheckHook ];

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
