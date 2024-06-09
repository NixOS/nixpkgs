{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  pytestCheckHook,
  syrupy,
  pillow,
  rich,
  pythonRelaxDepsHook,
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

  patches = [
    (fetchpatch {
      name = "fix-version.patch";
      url = "https://github.com/darrenburns/rich-pixels/commit/ff1cc3fef789321831f29e9bf282ae6b337eddb2.patch";
      hash = "sha256-58ZHBNg1RCuOfuE034qF1SbAgoiWMNlSG3c5pCSLUyI=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ syrupy ];

  propagatedBuildInputs = [
    pillow
    rich
  ];

  pythonRelaxDeps = [ "pillow" ];

  pythonImportsCheck = [ "rich_pixels" ];

  meta = with lib; {
    description = "A Rich-compatible library for writing pixel images and ASCII art to the terminal";
    homepage = "https://github.com/darrenburns/rich-pixels";
    changelog = "https://github.com/darrenburns/rich-pixels/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
