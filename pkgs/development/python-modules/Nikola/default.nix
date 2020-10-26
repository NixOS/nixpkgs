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
, aiohttp
, watchdog
}:

buildPythonPackage rec {
  pname = "Nikola";
  version = "8.1.1";

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
    phpserialize jinja2 toml notebook ruamel_yaml aiohttp watchdog
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "cee35b011667a965eca01b7d36b54649c9434ab004d8556d6563b7d899df61ed";
  };

  patchPhase = ''
    # upstream added bound so that requires.io doesn't send mails about update
    # nikola should work with markdown 3.0: https://github.com/getnikola/nikola/pull/3175#issue-220147596
    sed -i 's/Markdown>.*/Markdown/' requirements.txt
  '';

  checkPhase = ''
    LANG="en_US.UTF-8" LC_ALL="en_US.UTF-8" py.test .
  '';

  meta = {
    broken = true;
    homepage = "https://getnikola.com/";
    description = "A modular, fast, simple, static website and blog generator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
