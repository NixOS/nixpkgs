{ lib
, ajpy
, buildPythonPackage
, cx-oracle
, dnspython
, fetchPypi
, impacket
, ipy
, mysqlclient
, paramiko
, psycopg2
, pyasn1
, pycrypto
, pycurl
, pyopenssl
, pysnmp
, pysqlcipher3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "patator";
  version = "1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VQ7JPyQOY9X/7LVAvTwftoOegt4KyfERgu38HfmsYDM=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace psycopg2-binary psycopg2
  '';

  propagatedBuildInputs = [
    ajpy
    cx-oracle
    dnspython
    impacket
    ipy
    mysqlclient
    paramiko
    psycopg2
    pyasn1
    pycrypto
    pycurl
    pyopenssl
    pysnmp
    pysqlcipher3
  ];

  # tests require docker-compose and vagrant
  doCheck = false;

  meta = with lib; {
    description = "Multi-purpose brute-forcer";
    homepage = "https://github.com/lanjelot/patator";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ y0no ];
  };
}
