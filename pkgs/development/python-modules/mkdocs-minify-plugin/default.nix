{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mkdocs,
  csscompressor,
  htmlmin,
  jsmin,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mkdocs-minify-plugin";
  version = "0.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "byrnereese";
    repo = "mkdocs-minify-plugin";
    rev = "refs/tags/${version}";
    hash = "sha256-LDCAWKVbFsa6Y/tmY2Zne4nOtxe4KvNplZuWxg4e4L8=";
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

  # Some tests fail with an assertion error failure
  doCheck = false;

  pythonImportsCheck = [ "mkdocs" ];

  meta = with lib; {
    description = "Mkdocs plugin to minify the HTML of a page before it is written to disk";
    homepage = "https://github.com/byrnereese/mkdocs-minify-plugin";
    license = licenses.mit;
    maintainers = with maintainers; [ tfc ];
  };
}
