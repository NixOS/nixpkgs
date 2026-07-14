{
  lib,
  buildPythonPackage,
  editorconfig,
  fetchPypi,
  jsbeautifier,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cssbeautifier";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9hAsBYnIW+PBoBbO527jZh7kvV2ojUil+HCL+vZjriY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    editorconfig
    jsbeautifier
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "cssbeautifier" ];

  meta = {
    description = "CSS unobfuscator and beautifier";
    mainProgram = "css-beautify";
    homepage = "https://github.com/beautifier/js-beautify";
    changelog = "https://github.com/beautifier/js-beautify/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ traxys ];
  };
}
