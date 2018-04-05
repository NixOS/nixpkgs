{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "python-digitalocean";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12qybflfnl08acspz7rpaprmlabgrzimacbd7gm9qs5537hl3qnp";
  };

  propagatedBuildInputs = [ requests ];

  # Package doesn't distribute tests.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "digitalocean.com API to manage Droplets and Images";
    homepage = https://pypi.python.org/pypi/python-digitalocean;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ teh ];
  };
}
