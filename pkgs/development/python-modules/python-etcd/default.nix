{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
  mock,
  pyopenssl,
  urllib3,
  dnspython,
}:

buildPythonPackage rec {
  pname = "python-etcd";
  version = "0.4.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8bXruCWj6BkElPXOFQn96QafJ1SDjtkEAqjBHh9SuMs=";
  };

  buildInputs = [
    nose
    mock
    pyopenssl
  ];

  propagatedBuildInputs = [
    urllib3
    dnspython
  ];

  postPatch = ''
    sed -i '19s/dns/"dnspython"/' setup.py
  '';

  # Some issues with etcd not in path even though most tests passed
  doCheck = false;

  meta = with lib; {
    description = "Python client for Etcd";
    homepage = "https://github.com/jplana/python-etcd";
    license = licenses.mit;
  };
}
