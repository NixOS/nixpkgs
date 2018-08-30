{ stdenv, buildPythonPackage, fetchPypi, kitchen, requests, bunch, paver
, six, munch, urllib3, beautifulsoup4, openidc-client, lockfile }:

buildPythonPackage rec {
  pname = "python-fedora";
  version = "0.10.0";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5516b8c066bb2eb5d604ae8e84c3d31e27753795c5d84f6a792979363756405c";
  };
  propagatedBuildInputs = [ kitchen requests bunch paver lockfile
    six munch urllib3 beautifulsoup4 openidc-client ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python Fedora Module";
    homepage = https://github.com/fedora-infra/python-fedora;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
  };
}
