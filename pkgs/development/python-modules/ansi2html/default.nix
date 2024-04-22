{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "ansi2html";
  version = "1.9.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XGg3oT7MGQOqt6VFNTMSBJ3+3+UQU2KtOo2dIHhx7HE=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  preCheck = "export PATH=$PATH:$out/bin";

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ansi2html" ];

  meta = with lib; {
    description = "Convert text with ANSI color codes to HTML";
    mainProgram = "ansi2html";
    homepage = "https://github.com/ralphbean/ansi2html";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ davidtwco ];
  };
}
