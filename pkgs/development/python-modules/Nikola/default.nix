{ lib
, aiohttp
, Babel
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
, Mako
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
, PyRSS2Gen
, pytestCheckHook
, pythonOlder
, requests
, ruamel_yaml
, stdenv
, toml
, typogrify
, unidecode
, watchdog
, Yapsy
}:

buildPythonPackage rec {
  pname = "Nikola";
  version = "8.1.3";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05eac356bb4273cdd05d2dd6ad676226133496c457af91987c3f0d40e2fe57ef";
  };

  propagatedBuildInputs = [
    aiohttp
    Babel
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
    Mako
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
    PyRSS2Gen
    requests
    ruamel_yaml
    toml
    typogrify
    unidecode
    watchdog
    Yapsy
  ];

  checkInputs = [
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
  ];

  pythonImportsCheck = [ "nikola" ];

  meta = with lib; {
    description = "Static website and blog generator";
    homepage = "https://getnikola.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
    # All tests fail
    broken = stdenv.isDarwin;
  };
}
