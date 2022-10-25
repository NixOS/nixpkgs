{ lib, buildPythonPackage, fetchPypi, kitchen, requests, bunch, paver
, six, munch, urllib3, beautifulsoup4, openidc-client, lockfile }:

buildPythonPackage rec {
  pname = "python-fedora";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "56b9d841a39b4030e388e90c7b77dacd479f1ce5e2ff9b18c3954d97d5709a19";
  };
  propagatedBuildInputs = [ kitchen requests bunch paver lockfile
    six munch urllib3 beautifulsoup4 openidc-client ];
  doCheck = false;

  meta = with lib; {
    description = "Python Fedora Module";
    homepage = "https://github.com/fedora-infra/python-fedora";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
  };
}
