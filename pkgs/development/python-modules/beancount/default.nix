{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, beautifulsoup4
, bottle
, chardet
, dateutil
, google-api-python-client
, lxml
, oauth2client
, ply
, pytest
, python_magic
, requests
}:

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
    google-api-python-client
    lxml
    oauth2client
    ply
    python_magic
    requests
    # pytest really is a runtime dependency
    # https://github.com/beancount/beancount/blob/v2/setup.py#L81-L82
    pytest
  ];

  meta = with lib; {
    homepage = "http://furius.ca/beancount/";
    description = "Double-entry bookkeeping computer language";
    longDescription = ''
        A double-entry bookkeeping computer language that lets you define
        financial transaction records in a text file, read them in memory,
        generate a variety of reports from them, and provides a web interface.
    '';
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ bhipple ];
  };
}
