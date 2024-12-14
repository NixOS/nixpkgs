{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  beautifulsoup4,
  bottle,
  chardet,
  python-dateutil,
  google-api-python-client,
  google-auth-oauthlib,
  lxml,
  oauth2client,
  ply,
  pytest,
  python-magic,
  requests,
}:

buildPythonPackage rec {
  version = "2.3.6";
  format = "setuptools";
  pname = "beancount";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gB+Tvta1fS4iQ2aIxInVob8fduIQ887RhoB1fmDTR1o=";
  };

  # Tests require files not included in the PyPI archive.
  doCheck = false;

  propagatedBuildInputs = [
    beautifulsoup4
    bottle
    chardet
    python-dateutil
    google-api-python-client
    google-auth-oauthlib
    lxml
    oauth2client
    ply
    python-magic
    requests
    # pytest really is a runtime dependency
    # https://github.com/beancount/beancount/blob/v2/setup.py#L81-L82
    pytest
  ];

  meta = with lib; {
    homepage = "https://github.com/beancount/beancount";
    description = "Double-entry bookkeeping computer language";
    longDescription = ''
      A double-entry bookkeeping computer language that lets you define
      financial transaction records in a text file, read them in memory,
      generate a variety of reports from them, and provides a web interface.
    '';
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      sharzy
      polarmutex
    ];
  };
}
