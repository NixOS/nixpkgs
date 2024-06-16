{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonRelaxDepsHook,
  rapidfuzz,
  click,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "jiwer";
  version = "3.04";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = "jiwer";
    rev = "refs/tags/v${version}";
    hash = "sha256-2LzAOgABK00Pz3v5WWYUAcZOYcTbRKfgw7U5DOohB/Q=";
  };

  build-system = [
    poetry-core
    pythonRelaxDepsHook
  ];

  dependencies = [
    rapidfuzz
    click
  ];

  pythonRelaxDeps = [ "rapidfuzz" ];

  pythonImportsCheck = [ "jiwer" ];

  meta = with lib; {
    description = "A simple and fast python package to evaluate an automatic speech recognition system";
    mainProgram = "jiwer";
    homepage = "https://github.com/jitsi/jiwer";
    changelog = "https://github.com/jitsi/jiwer/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
