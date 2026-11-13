{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  karton-core,
  malduck,
}:

buildPythonPackage rec {
  pname = "karton-config-extractor";
  version = "2.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton-config-extractor";
    tag = "v${version}";
    hash = "sha256-JtR4Vwm0Qd6SNf2h872+fPTB4cegpuh1QH0wYSVGRgY=";
  };

  propagatedBuildInputs = [
    karton-core
    malduck
  ];

  pythonRelaxDeps = [ "malduck" ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "karton.config_extractor" ];

  meta = {
    description = "Static configuration extractor for the Karton framework";
    mainProgram = "karton-config-extractor";
    homepage = "https://github.com/CERT-Polska/karton-config-extractor";
    changelog = "https://github.com/CERT-Polska/karton-config-extractor/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
