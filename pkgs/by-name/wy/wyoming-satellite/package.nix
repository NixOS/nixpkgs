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
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-satellite";
    tag = "v${version}";
    hash = "sha256-9UgfD0Hs/IgOszd/QBbe6DYY6kBWh7q/e57gghQ1/Bk=";
  };

  build-system = with python.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = [
    "pyring-buffer"
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
