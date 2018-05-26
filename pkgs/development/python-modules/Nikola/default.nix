{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
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
, setuptools
, natsort
, requests
, piexif
, markdown
, phpserialize
, jinja2
}:

buildPythonPackage rec {
  pname = "Nikola";
  version = "7.8.14";

  # Nix contains only Python 3 supported version of doit, which is a dependency
  # of Nikola. Python 2 support would require older doit 0.29.0 (which on the
  # other hand doesn't support Python 3.3). So, just disable Python 2.
  disabled = !isPy3k;

  checkInputs = [ pytest pytestcov mock glibcLocales ];

  propagatedBuildInputs = [
    pygments pillow dateutil docutils Mako unidecode lxml Yapsy PyRSS2Gen
    Logbook blinker setuptools natsort requests piexif markdown phpserialize
    jinja2 doit
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d838817ac30ac6d4b8139a2adc8b49bed22dbb8fbc6261958d2775e10447d92";
  };

  meta = {
    homepage = https://getnikola.com/;
    description = "A modular, fast, simple, static website and blog generator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
