{ lib
, buildPythonPackage
, fetchPypi
, pytablewriter
, pytest
, tcolorpy
, typepy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-md-report";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iabj6WuS6+65O4ztagT1/H+U8/SKySQ9bQiOfvln1AQ=";
  };

  propagatedBuildInputs = [
    pytablewriter
    tcolorpy
    typepy
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_md_report" ];

  meta = with lib; {
    description = "A pytest plugin to make a test results report with Markdown table format";
    homepage = "https://github.com/thombashi/pytest-md-report";
    changelog = "https://github.com/thombashi/pytest-md-report/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ rrbutani ];
  };
}
