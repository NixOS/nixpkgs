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
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ofek";
    repo = "binary";
    tag = "v${version}";
    hash = "sha256-dU+E6MxAmH8AEGTW2/lZmtgRTinKCv9gDiVeb4n78U4=";
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
