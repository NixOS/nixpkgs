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
buildPythonPackage rec {
  pname = "beanquery";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "beanquery";
    tag = "v${version}";
    hash = "sha256-O7+WCF7s50G14oNTvJAOTvgSoNR9fWcn/m1jv7RHmK8=";
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
