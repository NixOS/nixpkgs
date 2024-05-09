{ lib
, buildPythonPackage
, fetchPypi
, nose
, mock
, pyopenssl
, urllib3
, dnspython
}:

buildPythonPackage rec {
  pname = "python-etcd";
  version = "0.4.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1b5ebb825a3e8190494f5ce1509fde9069f2754838ed90402a8c11e1f52b8cb";
  };

  buildInputs = [ nose mock pyopenssl ];

  propagatedBuildInputs = [ urllib3 dnspython ];

  postPatch = ''
    sed -i '19s/dns/"dnspython"/' setup.py
  '';

  # Some issues with etcd not in path even though most tests passed
  doCheck = false;

  meta = with lib; {
    description = "A python client for Etcd";
    homepage = "https://github.com/jplana/python-etcd";
    license = licenses.mit;
  };

}
