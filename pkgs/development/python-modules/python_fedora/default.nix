{ stdenv, buildPythonPackage, fetchPypi, kitchen, requests, bunch, paver
, six, munch, urllib3, beautifulsoup4, openidc-client, lockfile }:

buildPythonPackage rec {
  pname = "python-fedora";
  version = "0.9.0";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sf468scw52sw9pzxrnmqs54rix9c4fp1mi2r5k5n7mgjrmf6j0x";
  };
  propagatedBuildInputs = [ kitchen requests bunch paver lockfile
    six munch urllib3 beautifulsoup4 openidc-client ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python Fedora Module";
    homepage = https://github.com/fedora-infra/python-fedora;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ mornfall ];
  };
}
