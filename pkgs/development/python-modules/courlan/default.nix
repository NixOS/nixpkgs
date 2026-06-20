{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system,
  setuptools,

  # dependencies
  babel,
  langcodes,
  tld,
  urllib3,

  # tests
  pytest-httpserver,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "courlan";
  version = "1.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "adbar";
    repo = "courlan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hDbeAd/gil6S8zggBjmrDmnW3DMMdRvG1vULuhYA1zc=";
  };

  # Tests try to write to /tmp directly. use $TMPDIR instead.
  postPatch =
    let
      courlanBinPath = "${placeholder "out"}/bin/courlan";
    in
    ''
      substituteInPlace tests/unit_tests.py \
        --replace-fail \
          'assert os.system("courlan --help") == 0' \
          'assert os.system("${courlanBinPath} --help") == 0' \
        --replace-fail \
          'courlan_bin = "courlan"' \
          'courlan_bin = "${courlanBinPath}"'
    '';

  build-system = [ setuptools ];

  dependencies = [
    babel
    langcodes
    tld
    urllib3
  ];

  nativeCheckInputs = [
    pytest-httpserver
    pytestCheckHook
  ];

  # disable tests that require an internet connection
  disabledTests = [ "test_urlcheck" ];

  pythonImportsCheck = [ "courlan" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Clean, filter and sample URLs to optimize data collection";
    homepage = "https://github.com/adbar/courlan";
    changelog = "https://github.com/adbar/courlan/blob/${finalAttrs.src.tag}/HISTORY.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jokatzke ];
    mainProgram = "courlan";
  };
})
