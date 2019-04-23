{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, fetchpatch
, doit
, glibcLocales
, pytest
, pytestcov
, mock
, pygments
, pillow
, dateutil
, docutils
, Mako
, unidecode
, lxml
, Yapsy
, PyRSS2Gen
, Logbook
, blinker
, natsort
, requests
, piexif
, markdown
, phpserialize
, jinja2
, Babel
, freezegun
, toml
, notebook
, ruamel_yaml
}:

buildPythonPackage rec {
  pname = "Nikola";
  version = "8.0.2";

  # Nix contains only Python 3 supported version of doit, which is a dependency
  # of Nikola. Python 2 support would require older doit 0.29.0 (which on the
  # other hand doesn't support Python 3.3). So, just disable Python 2.
  disabled = !isPy3k;

  checkInputs = [ pytest pytestcov mock glibcLocales freezegun ];

  propagatedBuildInputs = [
    # requirements.txt
    doit pygments pillow dateutil docutils Mako markdown unidecode
    lxml Yapsy PyRSS2Gen Logbook blinker natsort requests piexif Babel
    # requirements-extras.txt
    phpserialize jinja2 toml notebook ruamel_yaml
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a5y1qriy76hl4yxvbf365b1ggsxybm06mi1pwb5jkgbkwk2gkrf";
  };

  checkPhase = ''
    LANG="en_US.UTF-8" LC_ALL="en_US.UTF-8" py.test .
  '';

  meta = {
    homepage = https://getnikola.com/;
    description = "A modular, fast, simple, static website and blog generator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
