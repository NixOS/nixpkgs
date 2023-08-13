{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, multidict
, xmljson
}:

buildPythonPackage rec {
  pname = "latex2mathml";
  version = "3.76.0";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "roniemartinez";
    repo = pname;
    rev = version;
    hash = "sha256-CoWXWgu1baM5v7OC+OlRHZB0NkPue4qFzylJk4Xq2e4=";
  };

  format = "pyproject";

  nativeBuildInputs = [
    poetry-core
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
