{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, mock
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "python-statsd";
  version = "2.1.0";
  disabled = isPy3k;  # next release will be py3k compatible

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2c573d325d0f015b4d79f0d0f8c88dd8413d7b9ef890c09076a9b6089ab301c";
  };

  buildInputs = [ mock nose coverage ];

  meta = with stdenv.lib; {
    description = "A client for Etsy's node-js statsd server";
    homepage = https://github.com/WoLpH/python-statsd;
    license = licenses.bsd3;
  };

}
