{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  stdenv,
  babel,
  beancount,
  beangulp,
  beanquery,
  cheroot,
  click,
  flask,
  flask-babel,
  hatch-vcs,
  hatchling,
  jinja2,
  markdown-it-py,
  msgspec,
  nodejs,
  npmHooks,
  pytestCheckHook,
  watchfiles,
  werkzeug,
}:
buildPythonPackage (finalAttrs: {
  pname = "fava";
  version = "1.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "fava";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3nBBDR34HlMdaPLagl90bwdPYlbHiF/hFtaQuwiuH3k=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps-${finalAttrs.version}";
    src = "${finalAttrs.src}/${finalAttrs.npmRoot}";
    hash = "sha256-DbnwXA5v2JrE6IEaqn03rhFbzhJ5yGVaITem2nYynyY=";
  };

  npmRoot = "frontend";

  postPatch = ''
    substituteInPlace tests/test_cli.py \
      --replace-fail '"fava"' '"${placeholder "out"}/bin/fava"'
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    babel
    beancount
    beangulp
    beanquery
    cheroot
    click
    flask
    flask-babel
    jinja2
    markdown-it-py
    msgspec
    werkzeug
    watchfiles
  ];

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fava" ];

  # tests/test_cli.py
  __darwinAllowLocalNetworking = true;

  # flaky, fails only on ci
  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [ "tests/test_core_watcher.py" ];

  env = {
    # Disable some tests when building with beancount2
    SNAPSHOT_IGNORE = lib.versions.major beancount.version == "2";
  };

  meta = {
    description = "Web interface for beancount";
    mainProgram = "fava";
    homepage = "https://beancount.github.io/fava";
    changelog = "https://beancount.github.io/fava/changelog.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      prince213
      sigmanificient
      cbrxyz
    ];
  };
})
