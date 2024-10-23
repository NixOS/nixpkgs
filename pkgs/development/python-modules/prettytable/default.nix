{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytest-lazy-fixtures,
  pytestCheckHook,
  pythonOlder,
  wcwidth,
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "3.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "prettytable";
    rev = "refs/tags/${version}";
    hash = "sha256-AxbrGJmNOvDXQaTS2PnefNtJVPo/QdXm1Pf94PG9Jdw=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [ wcwidth ];

  nativeCheckInputs = [
    pytest-lazy-fixtures
    pytestCheckHook
  ];

  pythonImportsCheck = [ "prettytable" ];

  meta = with lib; {
    description = "Display tabular data in a visually appealing ASCII table format";
    homepage = "https://github.com/jazzband/prettytable";
    changelog = "https://github.com/jazzband/prettytable/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
