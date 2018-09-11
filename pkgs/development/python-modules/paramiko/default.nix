{ stdenv
, buildPythonPackage
, fetchPypi
, python
, cryptography
, pyasn1
, isPyPy
, isPy33
}:

buildPythonPackage rec {
  pname = "paramiko";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xdmamqgx2ymhdm46q8flpj4fncj4wv2dqxzz0bc2dh7mnkss7fm";
  };

  propagatedBuildInputs = [ cryptography pyasn1 ];

  __darwinAllowLocalNetworking = true;

  # https://github.com/paramiko/paramiko/issues/449
  doCheck = !(isPyPy || isPy33);
  checkPhase = ''
    # test_util needs to resolve an hostname, thus failing when the fw blocks it
    sed '/UtilTest/d' -i test.py

    ${python}/bin/${python.executable} test.py --no-sftp --no-big-file
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/paramiko/paramiko/";
    description = "Native Python SSHv2 protocol library";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ aszlig ];

    longDescription = ''
      This is a library for making SSH2 connections (client or server).
      Emphasis is on using SSH2 as an alternative to SSL for making secure
      connections between python scripts. All major ciphers and hash methods
      are supported. SFTP client and server mode are both supported too.
    '';
  };
}
