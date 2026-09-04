{
  lib,
  python3Packages,
  piper-tts,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "wyoming-piper";
  version = "2.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "wyoming-piper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TjrH+v/s/strNSQl6LIweITDuMdL4bNIH3Jm6vz+jH4=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "regex"
    "sentence-stream"
    "wyoming"
  ];

  dependencies =
    with python3Packages;
    [
      regex
      piper-tts
      sentence-stream
      wyoming
    ]
    ++ wyoming.optional-dependencies.zeroconf;

  optional-dependencies = with python3Packages; {
    http = wyoming.optional-dependencies.http;
    # We do not follow the dependency dance upstream does as that would require overrideAttrs.
    # omnivoice = [ omnivoice ]; # not packaged, yet
    web = [ flask ];
    zeroconf = wyoming.optional-dependencies.zeroconf;
    zh = piper-tts.optional-dependencies.zh;
  };

  pythonImportsCheck = [
    "wyoming_piper"
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # requires network access
    "tests/test_piper.py"
  ];

  meta = {
    changelog = "https://github.com/OHF-Voice/wyoming-piper/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Wyoming Server for Piper";
    mainProgram = "wyoming-piper";
    homepage = "https://github.com/OHF-Voice/wyoming-piper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
