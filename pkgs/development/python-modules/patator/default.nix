{ lib, buildPythonPackage, isPy27, fetchPypi
, paramiko, pycurl, ajpy, impacket, pyopenssl, cx_oracle, mysqlclient
, psycopg2, pycrypto, dnspython, ipy, pysnmp, pyasn1, pysqlcipher3 }:


buildPythonPackage rec {
  pname = "patator";
  version = "0.9";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "68cb24bdc3042ee0d47a288b19a8b99a6c54bdbd4ddf0c5817d9b9ac0a0d8a15";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace psycopg2-binary psycopg2
  '';

  propagatedBuildInputs = [
    paramiko
    pycurl
    ajpy
    impacket
    pyopenssl
    cx_oracle
    mysqlclient
    psycopg2
    pycrypto
    dnspython
    ipy
    pysnmp
    pyasn1
    pysqlcipher3
  ];

  # tests require docker-compose and vagrant
  doCheck = false;

  meta = with lib; {
    description = "multi-purpose brute-forcer";
    homepage = "https://github.com/lanjelot/patator";
    license = licenses.gpl2;
    maintainers = with maintainers; [ y0no SuperSandro2000 ];
  };
}
