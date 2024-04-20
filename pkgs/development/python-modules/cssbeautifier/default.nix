{ lib
, buildPythonPackage
, editorconfig
, fetchPypi
, jsbeautifier
, pythonOlder
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "cssbeautifier";
  version = "1.15.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n3BkNirt1VnFXu7Pa2vtZeBfM0iNy+OQRPBAPCbhwAY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    editorconfig
    jsbeautifier
    six
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "cssbeautifier"
  ];

  meta = with lib; {
    description = "CSS unobfuscator and beautifier";
    mainProgram = "css-beautify";
    homepage = "https://github.com/beautifier/js-beautify";
    changelog = "https://github.com/beautifier/js-beautify/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ traxys ];
  };
}
