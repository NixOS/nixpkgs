{ lib
, aiohttp
, babel
, blinker
, buildPythonPackage
, python-dateutil
, docutils
, doit
, fetchPypi
, freezegun
, ghp-import
, hsluv
, html5lib
, ipykernel
, jinja2
, lxml
, mako
, markdown
, micawber
, mock
, natsort
, notebook
, phpserialize
, piexif
, pillow
, pygal
, pygments
, pyphen
, pyrss2gen
, pytestCheckHook
, pythonOlder
, requests
, ruamel-yaml
, stdenv
, toml
, typogrify
, unidecode
, watchdog
, yapsy
}:

buildPythonPackage rec {
  pname = "nikola";
  version = "8.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Nikola";
    inherit version;
    hash = "sha256-LNVk2zfNwY4CC4qulqfNXwi3mWyFxzWIeMykh6gFOL8=";
  };

  propagatedBuildInputs = [
    aiohttp
    babel
    blinker
    python-dateutil
    docutils
    doit
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

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov nikola --cov-report term-missing" ""
  '';

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
    homepage = "https://getnikola.com/";
    changelog = "https://github.com/getnikola/nikola/blob/v${version}/CHANGES.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
