{ stdenv
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, substituteAll
, xmlsec
, cryptography, defusedxml, future, pyopenssl, dateutil, pytz, requests, six
, mock, pyasn1, pymongo, pytest, responses
}:

buildPythonPackage rec {
  pname = "pysaml2";
  version = "5.0.0";

  disabled = !isPy3k;

  # No tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hwhxz45h8l1b0615hf855z7valfcmm0nb7k31bcj84v68zp5rjs";
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
