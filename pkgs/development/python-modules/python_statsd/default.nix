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
  version = "1.6.0";
  disabled = isPy3k;  # next release will be py3k compatible

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d2fc153e0d894aa9983531ef47d20d75bd4ee9fd0e46a9d82f452dde58a0a71";
  };

  buildInputs = [ mock nose coverage ];

  meta = with stdenv.lib; {
    description = "A client for Etsy's node-js statsd server";
    homepage = https://github.com/WoLpH/python-statsd;
    license = licenses.bsd3;
  };

}
