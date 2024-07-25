{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # optional-dependencies
  furo,
  myst-parser,
  sphinx-autobuild,
  sphinxHook,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiohappyeyeballs";
  version = "2.3.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiohappyeyeballs";
    rev = "refs/tags/v${version}";
    hash = "sha256-3Lj1eUDPoVCElrxowBhhrS0GCjD5qeUCiSB/gHoqC3Q=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=aiohappyeyeballs --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [ poetry-core ] ++ passthru.optional-dependencies.docs;

  passthru.optional-dependencies = {
    docs = [
      furo
      myst-parser
      sphinx-autobuild
      sphinxHook
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohappyeyeballs" ];

  disabledTestPaths = [
    # https://github.com/bdraco/aiohappyeyeballs/issues/30
    "tests/test_impl.py"
  ];

  meta = with lib; {
    description = "Happy Eyeballs for pre-resolved hosts";
    homepage = "https://github.com/bdraco/aiohappyeyeballs";
    changelog = "https://github.com/bdraco/aiohappyeyeballs/blob/v${version}/CHANGELOG.md";
    license = licenses.psfl;
    maintainers = with maintainers; [
      fab
      hexa
    ];
  };
}
