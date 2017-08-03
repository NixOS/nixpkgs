{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, doit
, glibcLocales
, pytest
, pytestcov
, pytest-mock
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
  name = "${pname}-${version}";
  pname = "Nikola";
  version = "7.8.9";

  # Nix contains only Python 3 supported version of doit, which is a dependency
  # of Nikola. Python 2 support would require older doit 0.29.0 (which on the
  # other hand doesn't support Python 3.3). So, just disable Python 2.
  disabled = !isPy3k;

  buildInputs = [ pytest pytestcov pytest-mock glibcLocales ];

  propagatedBuildInputs = [
    pygments pillow dateutil docutils Mako unidecode lxml Yapsy PyRSS2Gen
    Logbook blinker setuptools natsort requests piexif markdown phpserialize
    jinja2 doit
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "c85bf293a245a34057fb55236fc2f2c5d28e9ef1c375889f443bca1d86924df4";
  };

  meta = {
    homepage = https://getnikola.com/;
    description = "A modular, fast, simple, static website and blog generator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
