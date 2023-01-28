{ lib
, callPackage
, buildPythonPackage
, fetchFromGitHub
, mkdocs
, csscompressor
, htmlmin
, jsmin
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mkdocs-minify";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "byrnereese";
    repo = "${pname}-plugin";
    rev = "refs/tags/${version}";
    sha256 = "sha256-ABoLt5sFpt8Hm07tkqeAcs63ZvJ4vTbGw4QRYVYpMEA=";
  };

  propagatedBuildInputs = [
    csscompressor
    htmlmin
    jsmin
    mkdocs
  ];

  nativeCheckInputs = [
    mkdocs
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mkdocs" ];

  meta = with lib; {
    description = "A mkdocs plugin to minify the HTML of a page before it is written to disk.";
    homepage = "https://github.com/byrnereese/mkdocs-minify-plugin";
    license = licenses.mit;
    maintainers = with maintainers; [ tfc ];
  };
}
