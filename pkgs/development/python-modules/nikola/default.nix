{
  lib,
  aiohttp,
  babel,
  blinker,
  buildPythonPackage,
  docutils,
  doit,
  feedparser,
  fetchpatch,
  fetchPypi,
  freezegun,
  ghp-import,
  hsluv,
  html5lib,
  ipykernel,
  jinja2,
  lxml,
  mako,
  markdown,
  micawber,
  mock,
  natsort,
  notebook,
  phpserialize,
  piexif,
  pillow,
  pygal,
  pygments,
  pyphen,
  pyrss2gen,
  pytestCheckHook,
  pytest-cov-stub,
  python-dateutil,
  requests,
  ruamel-yaml,
  setuptools,
  stdenv,
  toml,
  typogrify,
  unidecode,
  watchdog,
  yapsy,
}:

buildPythonPackage rec {
  pname = "nikola";
  version = "8.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y219b/wqsk9MJknoaV+LtWBOMJFT6ktgt4b6yuA6scc=";
  };

  patches = [
    # Upstream PR: https://github.com/getnikola/nikola/pull/3878
    (fetchpatch {
      name = "python-3.14.patch";
      url = "https://github.com/getnikola/nikola/commit/635366b64149055844f2d2ef6070b456bd4ba245.patch";
      hash = "sha256-TmrYHEIvC8ZKngBJnnKcyU5S4kjzIjLk7KKm72hXx1A=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    babel
    blinker
    docutils
    doit
    feedparser
    ghp-import
    hsluv
    html5lib
    ipykernel
    jinja2
    lxml
    mako
    markdown
    micawber
    natsort
    notebook
    phpserialize
    piexif
    pillow
    pygal
    pygments
    pyphen
    pyrss2gen
    python-dateutil
    requests
    ruamel-yaml
    toml
    typogrify
    unidecode
    watchdog
    yapsy
  ];

  nativeCheckInputs = [
    freezegun
    mock
    pytestCheckHook
    pytest-cov-stub
  ];

  disabledTests = [
    # AssertionError
    "test_compiling_markdown"
    "test_write_content_does_not_detroy_text"
    # Date formatting slightly differs from expectation
    "test_format_date_long"
    "test_format_date_timezone"
    "test_format_date_locale_variants"
    "test_format_date_locale_variants"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Segfault in darwin sandbox via watchdog
    "tests/integration/test_dev_server_auto.py::test_serves_root_dir"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "nikola" ];

  meta = {
    description = "Static website and blog generator";
    homepage = "https://getnikola.com/";
    changelog = "https://github.com/getnikola/nikola/blob/v${version}/CHANGES.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
    mainProgram = "nikola";
  };
}
