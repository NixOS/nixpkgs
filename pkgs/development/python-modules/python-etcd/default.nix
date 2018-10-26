{ stdenv
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
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf53262b3890d185fe637eed15fe39c8d7a8261864ddcd7037b22c961456d7fc";
  };

  buildInputs = [ nose mock pyopenssl ];

  propagatedBuildInputs = [ urllib3 dnspython ];

  postPatch = ''
    sed -i '19s/dns/"dnspython"/' setup.py
  '';

  # Some issues with etcd not in path even though most tests passed
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A python client for Etcd";
    homepage = https://github.com/jplana/python-etcd;
    license = licenses.mit;
  };

}
