{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  rapidfuzz,
  click,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "jiwer";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = "jiwer";
    tag = "v${version}";
    hash = "sha256-iyFcxZGYMeQXSZBHJg7kBWyOciZyEV7gSzSy4SvBGzw=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    rapidfuzz
    click
  ];

  pythonRelaxDeps = [ "rapidfuzz" ];

  pythonImportsCheck = [ "jiwer" ];

  meta = with lib; {
    description = "Simple and fast python package to evaluate an automatic speech recognition system";
    mainProgram = "jiwer";
    homepage = "https://github.com/jitsi/jiwer";
    changelog = "https://github.com/jitsi/jiwer/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
