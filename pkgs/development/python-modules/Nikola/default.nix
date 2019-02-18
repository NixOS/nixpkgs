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
, setuptools
, natsort
, requests
, piexif
, markdown
, phpserialize
, jinja2
, Babel
, freezegun
, pyyaml
, toml
, notebook
}:

buildPythonPackage rec {
  pname = "Nikola";
  version = "8.0.1";

  # Nix contains only Python 3 supported version of doit, which is a dependency
  # of Nikola. Python 2 support would require older doit 0.29.0 (which on the
  # other hand doesn't support Python 3.3). So, just disable Python 2.
  disabled = !isPy3k;

  checkInputs = [ pytest pytestcov mock glibcLocales freezegun ];

  propagatedBuildInputs = [
    pygments pillow dateutil docutils Mako unidecode lxml Yapsy PyRSS2Gen
    Logbook blinker setuptools natsort requests piexif markdown phpserialize
    jinja2 doit Babel pyyaml toml notebook
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "18bq68f9v7xk9ahjl6x4k77yysq5g6g07ng2ndbg35kcsdnw4nk6";
  };

  patches = fetchpatch {
    url = https://github.com/getnikola/nikola/commit/d40be74a86af71b5206dc22beb82fcd0d08ea2f6.patch;
    sha256 = "0disr8bxbfjymwlbm82mxkal3ynnv8zfiqsgfh9fkqhb35bn4l8j";
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
