{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, setuptools
, pytestCheckHook
, multidict
, xmljson
}:

buildPythonPackage rec {
  pname = "latex2mathml";
  version = "3.75.2";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "roniemartinez";
    repo = pname;
    rev = version;
    hash = "sha256-i/F1B/Rndg66tiKok1PDMK/rT5c2e8upnQrMSCTUzpU=";
  };

  format = "pyproject";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    setuptools  # needs pkg_resources at runtime
  ];

  nativeCheckInputs = [
    pytestCheckHook
    multidict
    xmljson
  ];

  # Disable code coverage in check phase
  postPatch = ''
    sed -i '/--cov/d' pyproject.toml
  '';

  pythonImportsCheck = [ "latex2mathml" ];

  meta = with lib; {
    description = "Pure Python library for LaTeX to MathML conversion";
    homepage = "https://github.com/roniemartinez/latex2mathml";
    changelog = "https://github.com/roniemartinez/latex2mathml/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
