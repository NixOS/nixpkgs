{ lib, buildPythonPackage, fetchFromGitHub, poetry-core, setuptools
, multidict, pytestCheckHook, pytest-cov, xmljson }:

buildPythonPackage rec {
  pname = "latex2mathml";
  version = "3.75.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "roniemartinez";
    repo = pname;
    rev = version;
    hash = "sha256-i/F1B/Rndg66tiKok1PDMK/rT5c2e8upnQrMSCTUzpU=";
  };

  nativeBuildInputs = [ poetry-core ];
  propagatedBuildInputs = [ setuptools ];
  nativeCheckInputs = [ multidict pytestCheckHook pytest-cov xmljson ];

  meta = with lib; {
    description = "Pure Python library for LaTeX to MathML conversion";
    homepage = "https://github.com/roniemartinez/latex2mathml";
    changelog = "https://github.com/roniemartinez/latex2mathml/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ McSinyx ];
  };
}
