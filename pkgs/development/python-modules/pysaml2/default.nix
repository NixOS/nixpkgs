{ stdenv
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, xmlsec
, cryptography, defusedxml, future, pyopenssl, dateutil, pytz, requests, six
, mock, pyasn1, pymongo, pytest, responses
}:

buildPythonPackage rec {
  pname = "pysaml2";
  version = "4.7.0";

  # No tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bpfvy2xd3aqf79ihglmxlxnv7406184p99h5mn5h9ifs54vvhhl";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-xmlsec1-path.patch;
      inherit xmlsec;
    })
  ];

  propagatedBuildInputs = [ cryptography defusedxml future pyopenssl dateutil pytz requests six ];

  checkInputs = [ mock pyasn1 pymongo pytest responses ];

  # Disabled tests try to access the network
  checkPhase = ''
    py.test -k "not test_load_extern_incommon \
            and not test_load_remote_encoding \
            and not test_load_external"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/rohe/pysaml2";
    description = "Python implementation of SAML Version 2 Standard";
    license = licenses.asl20;
  };

}
