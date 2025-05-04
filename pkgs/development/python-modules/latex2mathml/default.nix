{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  multidict,
  xmljson,
}:

buildPythonPackage rec {
  pname = "latex2mathml";
  version = "3.78.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "roniemartinez";
    repo = pname;
    tag = version;
    hash = "sha256-FB1VM2z9y17q+6/wv4oTrhe/rD2QzdAc0VMbFmcrIAw=";
  };

  build-system = [ poetry-core ];

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
    changelog = "https://github.com/roniemartinez/latex2mathml/releases/tag/${src.tag}";
    license = licenses.mit;
    mainProgram = "latex2mathml";
    maintainers = with maintainers; [ sfrijters ];
  };
}
