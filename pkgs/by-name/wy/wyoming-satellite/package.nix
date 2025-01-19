{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

let
  python = python3Packages.python.override {
    self = python;
    packageOverrides = self: super: {
      wyoming = super.wyoming.overridePythonAttrs (oldAttrs: rec {
        version = "1.5.4";
        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          tag = version;
          hash = "sha256-gx9IbFkwR5fiFFAZTiQKzBbVBJ/RYz29sztgbvAEeRQ=";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "wyoming-satellite";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-satellite";
    tag = "v${version}";
    hash = "sha256-KIWhWE9Qaxs72fJ1LRTkvk6QtpBJOFlmZv2od69O15g=";
  };

  build-system = with python.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = [
    "wyoming"
    "zeroconf"
  ];

  dependencies = with python.pkgs; [
    pyring-buffer
    wyoming
    zeroconf
  ];

  optional-dependencies = {
    silerovad = with python3Packages; [
      pysilero-vad
    ];
    webrtc = with python3Packages; [
      webrtc-noise-gain
    ];
  };

  pythonImportsCheck = [
    "wyoming_satellite"
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Remote voice satellite using Wyoming protocol";
    homepage = "https://github.com/rhasspy/wyoming-satellite";
    changelog = "https://github.com/rhasspy/wyoming-satellite/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "wyoming-satellite";
  };
}
