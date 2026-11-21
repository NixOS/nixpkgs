{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  karton-core,
  malduck,
}:

buildPythonPackage rec {
  pname = "karton-config-extractor";
  version = "3.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton-config-extractor";
    tag = "v${version}";
    hash = "sha256-EhvMPlwrKlh5M1R0mVBiSdFhPQiYjWSUKEMt200o3mI=";
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
