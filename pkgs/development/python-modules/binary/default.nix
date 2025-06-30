{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "binary";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ofek";
    repo = "binary";
    tag = "v${version}";
    hash = "sha256-PbQlD/VR5KKoQ3+C6pnNoA/BJB5CEnXh6Q8CVZH/6cs=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "binary"
    "binary.core"
  ];

  meta = with lib; {
    changelog = "https://github.com/ofek/binary/releases/tag/${src.tag}";
    description = "Easily convert between binary and SI units (kibibyte, kilobyte, etc.)";
    homepage = "https://github.com/ofek/binary";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
}
