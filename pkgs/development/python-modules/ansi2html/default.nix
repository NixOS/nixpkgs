{ lib, buildPythonPackage, fetchPypi, isPy3k, six, mock, pytestCheckHook, setuptools, setuptools_scm, toml }:

buildPythonPackage rec {
  pname = "ansi2html";
  version = "1.6.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f124ea7efcf3f24f1f9398e527e688c9ae6eab26b0b84e1299ef7f94d92c596";
  };

  nativeBuildInputs = [ setuptools_scm toml ];
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
