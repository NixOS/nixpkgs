{
  lib,
  ajpy,
  buildPythonPackage,
  cx-oracle,
  dnspython,
  fetchPypi,
  impacket,
  ipy,
  mysqlclient,
  paramiko,
  psycopg2,
  pyasn1,
  pycrypto,
  pycurl,
  pyopenssl,
  pysnmp,
  pysqlcipher3,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "patator";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BupB/s4HNk6DUxbrHB/onqeS7kL0WsGPZ2jqKUj7DJw=";
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
    # Still uses cx-oracle which is broken and was replaced by oracledb
    # https://github.com/lanjelot/patator/issues/234
    broken = true;
  };
}
