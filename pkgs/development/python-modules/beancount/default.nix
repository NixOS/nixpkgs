{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, beautifulsoup4, bottle, chardet, dateutil
, google_api_python_client, lxml, ply, python_magic
, nose }:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "beancount";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wxwf02d3raglwqsxdsgf89fniakv1m19q825w76k5z004g18y42";
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

