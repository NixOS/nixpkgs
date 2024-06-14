{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "wyoming-satellite";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-satellite";
    rev = "refs/tags/v${version}";
    hash = "sha256-KIWhWE9Qaxs72fJ1LRTkvk6QtpBJOFlmZv2od69O15g=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "wyoming"
    "zeroconf"
  ];

  propagatedBuildInputs = with python3Packages; [
    pyring-buffer
    wyoming
    zeroconf
  ];

  passthru.optional-dependencies = {
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
