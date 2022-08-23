{ lib
, buildPythonPackage
, fetchFromGitHub
, markdown
}:

buildPythonPackage rec {
  pname = "markdown-include";
  version = "0.7.0";
  format = "setuptools";

  # only wheel on pypi
  src = fetchFromGitHub {
    owner = "cmacmackin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2pC0K/Z5l7q6sx4FSM4Pi1/5bt1wLZsqOmcbnE47rVs=";
  };

  propagatedBuildInputs = [
    markdown
  ];

  pythonImportsCheck = [
    "markdown_include"
  ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Extension to Python-Markdown which provides an include function";
    homepage = "https://github.com/cmacmackin/markdown-include";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
