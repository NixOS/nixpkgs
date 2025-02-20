{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-satellite";
    tag = "v${version}";
    hash = "sha256-sAtyyS60Fr6iFE3tTxEgAjhmX6O5WjWwb9rk+phzrtM=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/rhasspy/wyoming-satellite/pull/285
      url = "https://github.com/rhasspy/wyoming-satellite/commit/69465fd56011179cb92e7ce95da2e79fb06a83fb.patch";
      hash = "sha256-njJ8kIVGOpYK6bDeGow3OSNHxKQ9NsUKAR3+lEUH3GE=";
    })
  ];

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

  optional-dependencies = lib.fix (self: {
    all = self.silerovad ++ self.webrtc;
    respeaker = with python3Packages; [
      gpiozero
      spidev
    ];
    silerovad = with python3Packages; [
      pysilero-vad
    ];
    webrtc = with python3Packages; [
      webrtc-noise-gain
    ];
  });

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
