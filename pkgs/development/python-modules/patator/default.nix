{ stdenv, buildPythonPackage, isPy3k, fetchPypi,
  paramiko, pycurl, ajpy, pyopenssl, cx_oracle, mysqlclient,
  psycopg2, pycrypto, dnspython, ipy, pysnmp, pyasn1 }:


buildPythonPackage rec {
  pname = "patator";
  version = "0.9";
  disabled = !(isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "68cb24bdc3042ee0d47a288b19a8b99a6c54bdbd4ddf0c5817d9b9ac0a0d8a15";
  };

  propagatedBuildInputs = [
    paramiko
    pycurl
    ajpy
    pyopenssl
    cx_oracle
    mysqlclient
    psycopg2
    pycrypto
    dnspython
    ipy
    pysnmp
    pyasn1
  ];

  # No tests provided by patator
  doCheck = false;

  meta = with stdenv.lib; {
    description = "multi-purpose brute-forcer";
    homepage = "https://github.com/lanjelot/patator";
    license = licenses.gpl2;
    maintainers = with maintainers; [ y0no ];
  };
}
