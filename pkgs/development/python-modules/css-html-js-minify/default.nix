{
  lib,
  buildPythonPackage,
  fetchPypi,
  distutils,
  setuptools,
}:

buildPythonPackage rec {
  pname = "css-html-js-minify";
  version = "2.5.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-Sp8R9+BJb1KE0SER87pP9f8gI9EvFdGVycSL2XATdGw=";
  };

  build-system = [
    distutils
    setuptools
  ];

  # Tests are useless and broken
  doCheck = false;

  pythonImportsCheck = [ "css_html_js_minify" ];

  meta = {
    description = "StandAlone Async cross-platform Minifier for the Web";
    homepage = "https://github.com/juancarlospaco/css-html-js-minify";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
      mit
    ];
    maintainers = with lib.maintainers; [ FlorianFranzen ];
    mainProgram = "css-html-js-minify";
  };
}
