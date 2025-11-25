{
  lib,
  aiohttp,
  babel,
  blinker,
  buildPythonPackage,
  docutils,
  doit,
  feedparser,
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
  pythonOlder,
  requests,
  ruamel-yaml,
  setuptools,
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

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y219b/wqsk9MJknoaV+LtWBOMJFT6ktgt4b6yuA6scc=";
  };

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

  pythonImportsCheck = [ "nikola" ];

  meta = with lib; {
    description = "Static website and blog generator";
    homepage = "https://getnikola.com/";
    changelog = "https://github.com/getnikola/nikola/blob/v${version}/CHANGES.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
    mainProgram = "nikola";
  };
}
