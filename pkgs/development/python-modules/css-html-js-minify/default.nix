{
  lib,
  buildPythonPackage,
  fetchPypi,
  distutils,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "css-html-js-minify";
  version = "2.5.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

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

  meta = with lib; {
    description = "StandAlone Async cross-platform Minifier for the Web";
    homepage = "https://github.com/juancarlospaco/css-html-js-minify";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
      mit
    ];
    maintainers = with maintainers; [ FlorianFranzen ];
    mainProgram = "css-html-js-minify";
  };
}
