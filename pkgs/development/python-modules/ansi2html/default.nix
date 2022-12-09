{ lib, buildPythonPackage, fetchPypi, isPy3k, six, mock, pytestCheckHook, setuptools, setuptools-scm }:

buildPythonPackage rec {
  pname = "ansi2html";
  version = "1.8.0";
  format = "pyproject";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OLgqKYSCofomE/D5yb6z23Ko+DLurFjrLke/Ms039tU=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ six setuptools ];

  preCheck = "export PATH=$PATH:$out/bin";
  checkInputs = [ mock pytestCheckHook ];

  pythonImportsCheck = [ "ansi2html" ];

  meta = with lib; {
    description = "Convert text with ANSI color codes to HTML";
    homepage = "https://github.com/ralphbean/ansi2html";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ davidtwco ];
  };
}
