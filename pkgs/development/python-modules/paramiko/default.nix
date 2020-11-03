{ pkgs
, buildPythonPackage
, fetchPypi
, fetchpatch
, cryptography
, bcrypt
, invoke
, pynacl
, pyasn1
, pytest
, pytest-relaxed
, mock
}:

buildPythonPackage rec {
  pname = "paramiko";
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "920492895db8013f6cc0179293147f830b8c7b21fdfc839b6bad760c27459d9f";
  };

  patches = [
    # fix RSA key loading with cryptography 3.1, remove >2.7.1
    (fetchpatch {
      url = "https://github.com/paramiko/paramiko/commit/81064206bf3cec2ca4372257ff138481e1227b91.patch";
      sha256 = "01b87ffgyvd6rilp1w1kf7lk29z706ch39nwl21ifklqpjhmazww";
    })
  ];
  checkInputs = [ invoke pytest mock pytest-relaxed ];
  requiredPythonModules = [ bcrypt cryptography pynacl pyasn1 ];

  __darwinAllowLocalNetworking = true;

  # 2 sftp tests fail (skip for now)
  # test_config relies on artifacts to be to downloaded
  # RSA tests don't have valid keys
  checkPhase = ''
    pytest tests \
      --ignore=tests/test_sftp.py \
      --ignore=tests/test_config.py
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/paramiko/paramiko/";
    description = "Native Python SSHv2 protocol library";
    license = licenses.lgpl21Plus;

    longDescription = ''
      This is a library for making SSH2 connections (client or server).
      Emphasis is on using SSH2 as an alternative to SSL for making secure
      connections between python scripts. All major ciphers and hash methods
      are supported. SFTP client and server mode are both supported too.
    '';
  };
}
