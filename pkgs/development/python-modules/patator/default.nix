<<<<<<< HEAD
{ lib
, ajpy
, buildPythonPackage
, cx_oracle
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
=======
{ lib, buildPythonPackage, isPy27, fetchPypi
, paramiko, pycurl, ajpy, impacket, pyopenssl, cx_oracle, mysqlclient
, psycopg2, pycrypto, dnspython, ipy, pysnmp, pyasn1, pysqlcipher3 }:

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "patator";
  version = "0.9";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aMskvcMELuDUeiiLGai5mmxUvb1N3wxYF9m5rAoNihU=";
=======
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "68cb24bdc3042ee0d47a288b19a8b99a6c54bdbd4ddf0c5817d9b9ac0a0d8a15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace psycopg2-binary psycopg2
  '';

  propagatedBuildInputs = [
<<<<<<< HEAD
    ajpy
    cx_oracle
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pysqlcipher3
  ];

  # tests require docker-compose and vagrant
  doCheck = false;

  meta = with lib; {
<<<<<<< HEAD
    description = "Multi-purpose brute-forcer";
    homepage = "https://github.com/lanjelot/patator";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ y0no ];
=======
    description = "multi-purpose brute-forcer";
    homepage = "https://github.com/lanjelot/patator";
    license = licenses.gpl2;
    maintainers = with maintainers; [ y0no SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
