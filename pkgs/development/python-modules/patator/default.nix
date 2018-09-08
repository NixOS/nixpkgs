{ stdenv, buildPythonPackage, isPy3k, fetchPypi,
  paramiko, pycurl, ajpy, pyopenssl, cx_oracle, mysqlclient,
  psycopg2, pycrypto, dnspython, ipy, pysnmp, pyasn1 }:


buildPythonPackage rec {
  pname = "patator";
  version = "0.7";
  disabled = !(isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "335e432e6cc591437e316ba8c1da935484ca39fc79e595ccf60ccd9166e965f1";
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
    homepage = https://github.com/lanjelot/patator;
    license = licenses.gpl2;
    maintainers = with maintainers; [ y0no ];
  };
}
