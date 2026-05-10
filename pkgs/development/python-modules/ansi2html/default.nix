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
  version = "1.9.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NFO/h1NdN7gnsFJF+qp1bbq07D1pkl41K2MZw8lVwKU=";
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
