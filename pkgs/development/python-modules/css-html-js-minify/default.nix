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
    sha256 = "4a9f11f7e0496f5284d12111f3ba4ff5ff2023d12f15d195c9c48bd97013746c";
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
