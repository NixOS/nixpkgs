{ lib
, buildPythonPackage
, fetchFromGitHub
, markdown
}:

buildPythonPackage rec {
  pname = "markdown-include";
  version = "0.8.0";
  format = "setuptools";

  # only wheel on pypi
  src = fetchFromGitHub {
    owner = "cmacmackin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-wTGgxvM3/h+6plUcheeMSkpk1we7pwuWHurkDkmbnPY=";
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
