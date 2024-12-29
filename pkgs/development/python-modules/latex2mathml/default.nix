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
  version = "3.77.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "roniemartinez";
    repo = pname;
    rev = version;
    hash = "sha256-DLdSFMsNA0gD6Iw0kn+0IrbvyI0VEGOpz0ZYD48nRkY=";
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
    changelog = "https://github.com/roniemartinez/latex2mathml/releases/tag/${version}";
    license = licenses.mit;
    mainProgram = "latex2mathml";
    maintainers = with maintainers; [ sfrijters ];
  };
}
