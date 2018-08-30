{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, beautifulsoup4, bottle, chardet, dateutil
, google_api_python_client, lxml, ply, python_magic
, nose, requests }:

buildPythonPackage rec {
  version = "2.1.2";
  pname = "beancount";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d0d5f7088cb6b699cc4d030dad42d20b8228232cdb445bb1330d4ef5e3581f52";
  };

  checkInputs = [ nose ];

  # Automatic tests cannot be run because it needs to import some local modules for tests.
  doCheck = false;
  checkPhase = ''
    nosetests
  '';

  propagatedBuildInputs = [
    beautifulsoup4
    bottle
    chardet
    dateutil
    google_api_python_client
    lxml
    ply
    python_magic
    requests
  ];

  meta = {
    homepage = http://furius.ca/beancount/;
    description = "Double-entry bookkeeping computer language";
    longDescription = ''
        A double-entry bookkeeping computer language that lets you define
        financial transaction records in a text file, read them in memory,
        generate a variety of reports from them, and provides a web interface.
    '';
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}

