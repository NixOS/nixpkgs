{ lib, buildPythonPackage, fetchPypi
, decorator
, six
, requests
, pytz
, dateutil
, python_magic
, pytest
}:

buildPythonPackage rec {
  pname = "Mastodon.py";
  version = "1.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1229wbckanp08bbqajsn31ggvay271d883nca28wpvsaqdsv8ci5";
  };

  propagatedBuildInputs = [
    decorator
    six
    requests
    pytz
    dateutil
    python_magic
    setuptools
  ];

  checkInputs = [ pytest ];

  checkPhase = ''
    rm pytest.ini
    py.test
  '';

  doCheck = false; # fails with "py.test: error: unrecognized arguments: --cov=mastodon"

  meta = with lib; {
    homepage = "https://github.com/halcy/Mastodon.py";
    description = "Python wrapper for the Mastodon API";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}
