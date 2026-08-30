{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "ansi2html";
  version = "1.9.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GQs/xl8FRf7GRCUn+PVRMZSUEP6XwVrEKkQfHpZyb1c=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  preCheck = "export PATH=$PATH:$out/bin";

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ansi2html" ];

  meta = {
    description = "Convert text with ANSI color codes to HTML";
    mainProgram = "ansi2html";
    homepage = "https://github.com/ralphbean/ansi2html";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
