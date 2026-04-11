{
  lib,
  buildPythonPackage,
  editorconfig,
  fetchPypi,
  jsbeautifier,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "cssbeautifier";
  version = "1.15.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m7CNw/ZMEBoBZ38Sis8BkFkUz0Brr4dDTc3gW3TArPU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    editorconfig
    jsbeautifier
    six
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
