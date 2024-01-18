{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, syrupy
, pillow
, rich
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "rich-pixels";
  version = "2.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "rich-pixels";
    rev = version;
    hash = "sha256-fbpnHEfBPWLSYhgETqKbdmmzt7Lu/4oKgetjgNvv04c=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    syrupy
  ];

  propagatedBuildInputs = [
    pillow
    rich
  ];

  pythonRelaxDeps = [
    "pillow"
  ];

  pythonImportsCheck = [ "rich_pixels" ];

  meta = with lib; {
    description = "A Rich-compatible library for writing pixel images and ASCII art to the terminal";
    homepage = "https://github.com/darrenburns/rich-pixels";
    changelog = "https://github.com/darrenburns/rich-pixels/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
