{ stdenv, buildPythonPackage, fetchPypi, requests, jsonpickle }:

buildPythonPackage rec {
  pname = "python-digitalocean";
  version = "1.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h4drpdsmk0b3rlvg6q6cz11k23w0swj1iddk7xdcw4m7r7c52kw";
  };

  propagatedBuildInputs = [ requests jsonpickle ];

  # Package doesn't distribute tests.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "digitalocean.com API to manage Droplets and Images";
    homepage = https://pypi.python.org/pypi/python-digitalocean;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ teh ];
  };
}
