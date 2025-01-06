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
  version = "8.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "Nikola";
    inherit version;
    hash = "sha256-IfJB2Rl3c1MyEiuyNpT3udfpM480VvFD8zosJFDHr7k=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov nikola --cov-report term-missing" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
  ];

  disabledTests = [
    # AssertionError
    "test_compiling_markdown"
    # Date formatting slightly differs from expectation
    "test_format_date_long"
    "test_format_date_timezone"
    "test_format_date_locale_variants"
    "test_format_date_locale_variants"
  ];

  pythonImportsCheck = [ "nikola" ];

  meta = with lib; {
    description = "Static website and blog generator";
    mainProgram = "nikola";
    homepage = "https://getnikola.com/";
    changelog = "https://github.com/getnikola/nikola/blob/v${version}/CHANGES.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
