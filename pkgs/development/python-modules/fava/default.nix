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
  jinja2,
  markdown2,
  nodejs,
  npmHooks,
  ply,
  pytestCheckHook,
  setuptools-scm,
  simplejson,
  watchfiles,
  werkzeug,
}:
buildPythonPackage (finalAttrs: {
  pname = "fava";
  version = "1.30.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "fava";
    tag = "v${finalAttrs.version}";
    hash = "sha256-whfFXZjhZl69cUie/7xFLcsvqUmpDRHVAO56HEsz0HE=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps-${finalAttrs.version}";
    src = "${finalAttrs.src}/${finalAttrs.npmRoot}";
    hash = "sha256-FFqBomnTbiJLaxMtEKPkb4/ASFbtcF6lR/MbcK+MiaQ=";
  };

  npmRoot = "frontend";

  postPatch = ''
    substituteInPlace tests/test_cli.py \
      --replace-fail '"fava"' '"${placeholder "out"}/bin/fava"'
  '';

  build-system = [ setuptools-scm ];

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
    markdown2
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
