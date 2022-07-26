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
, ruamel-yaml
, stdenv
, toml
, typogrify
, unidecode
, watchdog
, Yapsy
}:

buildPythonPackage rec {
  pname = "Nikola";
  version = "8.2.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lfSrBRwkWMHTFEJ4KmrWIx9XIMO5I9XxcuJe7zTxJsE=";
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
    ruamel-yaml
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
