{ stdenv, buildPythonPackage, fetchPypi, kitchen, requests, bunch, paver
, six, munch, urllib3, beautifulsoup4, openidc-client, lockfile }:

buildPythonPackage rec {
  pname = "python-fedora";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "efb675929ebf588c2deffa2058ff407e65d1889bca1b545a58f525135367c9e4";
  };
  propagatedBuildInputs = [ kitchen requests bunch paver lockfile
    six munch urllib3 beautifulsoup4 openidc-client ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python Fedora Module";
    homepage = "https://github.com/fedora-infra/python-fedora";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
  };
}
