{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  beautifulsoup4,
  datetime,
  lxml,
  pandas,
  pytest-mock,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "finvizfinance";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lit26";
    repo = "finvizfinance";
    tag = "v${version}";
    hash = "sha256-M/EyQgINdJLLfOFNm/RhqONz3slb4ukugHLdiozDY0s=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  dependencies = [
    beautifulsoup4
    datetime
    lxml
    pandas
    requests
  ];

  pythonImportsCheck = [ "finvizfinance" ];

  disabledTests = [
    # Tests require network access
    "test_finvizfinance_calendar"
    "test_finvizfinance_crypto"
    "test_forex_performance_percentage"
    "test_group_overview"
    "test_finvizfinance_insider"
    "test_finvizfinance_news"
    "test_finvizfinance_finvizfinance"
    "test_statements"
    "test_screener_overview"
  ];

  meta = {
    description = "Finviz Finance information downloader";
    homepage = "https://github.com/lit26/finvizfinance";
    changelog = "https://github.com/lit26/finvizfinance/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ icyrockcom ];
  };
}
