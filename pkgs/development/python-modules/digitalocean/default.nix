{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "python-digitalocean";
  version = "1.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06391cf0b253c8b4a5a10b3a4b7b7808b890a1d1e3b43d5ce3b5293a9c77af6b";
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
