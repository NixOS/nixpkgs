{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "css-html-js-minify";
  version = "2.5.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-Sp8R9+BJb1KE0SER87pP9f8gI9EvFdGVycSL2XATdGw=";
  };

  doCheck = false; # Tests are useless and broken

  pythonImportsCheck = [ "css_html_js_minify" ];

  meta = with lib; {
    description = "StandAlone Async cross-platform Minifier for the Web";
    mainProgram = "css-html-js-minify";
    homepage = "https://github.com/juancarlospaco/css-html-js-minify";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
      mit
    ];
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
