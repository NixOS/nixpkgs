{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  rapidfuzz,
  click,
}:

buildPythonPackage rec {
  pname = "jiwer";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = "jiwer";
    tag = "v${version}";
    hash = "sha256-iyFcxZGYMeQXSZBHJg7kBWyOciZyEV7gSzSy4SvBGzw=";
  };

  build-system = [
    hatchling
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
