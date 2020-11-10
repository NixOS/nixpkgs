{ stdenv, fetchPypi, buildPythonPackage
, boto3, requests, gradient_statsd, terminaltables
, click-completion , click-didyoumean, click-help-colors
, colorama, requests_toolbelt, gradient_sdk, progressbar2
}:

buildPythonPackage rec {
  pname = "paperspace";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7959305128fea6da8ca0cdc528783a89859dacb9b54bf8eb89fd04a518872191";
  };

  propagatedBuildInputs = [ boto3 requests gradient_statsd terminaltables
    click-completion click-didyoumean click-help-colors requests_toolbelt
    colorama gradient_sdk progressbar2
  ];

  # tries to use /homeless-shelter to mimic container usage, etc
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python API for Paperspace Cloud";
    homepage    = "https://paperspace.com";
    license     = licenses.isc;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
