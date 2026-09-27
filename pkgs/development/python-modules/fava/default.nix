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
  nodejs,
  npmHooks,
  ply,
  pytestCheckHook,
  simplejson,
  watchfiles,
  werkzeug,
}:
buildPythonPackage (finalAttrs: {
  pname = "fava";
  version = "1.30.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "fava";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TXsDfNZrqTfHZ1rH3JHPSS103ab6nxP3BOFrUQ8CQH4=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps-${finalAttrs.version}";
    src = "${finalAttrs.src}/${finalAttrs.npmRoot}";
    hash = "sha256-WjdFEZqfD2rJpKs5ad7/YUlgBBrO92DGkiTp9v5PJhE=";
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
    ply
    simplejson
    werkzeug
    watchfiles
  ];

  pythonRelaxDeps = [ "simplejson" ];

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
