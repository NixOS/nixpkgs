{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, beautifulsoup4, bottle, chardet, dateutil
, google_api_python_client, lxml, oauth2client
, ply, python_magic, pytest, requests }:

buildPythonPackage rec {
  version = "2.3.3";
  pname = "beancount";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0767ap2n9vk9dz40njndfhaprajr75fvzx7igbd1szc6x8wri8nr";
  };

  # Tests require files not included in the PyPI archive.
  doCheck = false;

  propagatedBuildInputs = [
    beautifulsoup4
    bottle
    chardet
    dateutil
    google_api_python_client
    lxml
    oauth2client
    ply
    python_magic
    requests
    # pytest really is a runtime dependency
    # https://bitbucket.org/blais/beancount/commits/554e13057551951e113835196770847c788dd592
    pytest
  ];

  meta = {
    homepage = "http://furius.ca/beancount/";
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

