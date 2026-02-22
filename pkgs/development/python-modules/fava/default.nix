{
  lib,
  buildPythonPackage,
  buildNpmPackage,
  fetchpatch2,
  fetchFromGitHub,
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
  ply,
  pytestCheckHook,
  setuptools-scm,
  simplejson,
  watchfiles,
  werkzeug,
}:
let
  src = buildNpmPackage (finalAttrs: {
    pname = "fava-frontend";
    version = "1.30.9";

    src = fetchFromGitHub {
      owner = "beancount";
      repo = "fava";
      tag = "v${finalAttrs.version}";
      hash = "sha256-/Tnu1SgYhd22HVEzOtJ8YEHyxXuQ9xW0c/1oRyVePXw=";
    };
    sourceRoot = "${finalAttrs.src.name}/frontend";

    npmDepsHash = "sha256-5ee044Ev2FoxcdChZwfHnLQiiP+Ag4bNSAlzEnenAa0=";
    makeCacheWritable = true;

    preBuild = ''
      chmod -R u+w ..
    '';

    installPhase = ''
      runHook preInstall
      cp -R .. $out
      runHook postInstall
    '';
  });
in
buildPythonPackage {
  pname = "fava";
  inherit (src) version;
  pyproject = true;

  inherit src;

  patches = [
    ./dont-compile-frontend.patch
    # https://github.com/beancount/fava/pull/2176
    (fetchpatch2 {
      name = "fix-have-excel-replacement.patch";
      url = "https://github.com/beancount/fava/commit/36eba34495d189cd391fae0276aa1b6c94940203.patch?full_index=1";
      hash = "sha256-XSkzygnq8eHkIcp1TT7J3NdcLCIwUxDoyipO4M9M3nE=";
    })
  ];

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
    ];
  };
}
