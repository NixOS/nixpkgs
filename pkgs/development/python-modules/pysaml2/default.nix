{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, substituteAll
, xmlsec
, cryptography, defusedxml, pyopenssl, python-dateutil, pytz, requests, six
, mock, pyasn1, pymongo, pytest, responses, xmlschema, importlib-resources
}:

buildPythonPackage rec {
  pname = "pysaml2";
  version = "7.0.1";

  disabled = !isPy3k;

  # No tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ickqask6bjipgi3pvxg92pjr6dk2rr3q9garap39mdrp2gsfhln";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-xmlsec1-path.patch;
      inherit xmlsec;
    })
  ];

  postPatch = ''
    # fix failing tests on systems with 32bit time_t
    sed -i 's/2999\(-.*T\)/2029\1/g' tests/*.xml
  '';

  propagatedBuildInputs = [
    cryptography
    python-dateutil
    defusedxml
    importlib-resources
    pyopenssl
    pytz
    requests
    six
    xmlschema
  ];

  checkInputs = [ mock pyasn1 pymongo pytest responses ];

  # Disabled tests try to access the network
  checkPhase = ''
    py.test -k "not test_load_extern_incommon \
            and not test_load_remote_encoding \
            and not test_load_external \
            and not test_conf_syslog"
  '';

  meta = with lib; {
    homepage = "https://github.com/rohe/pysaml2";
    description = "Python implementation of SAML Version 2 Standard";
    license = licenses.asl20;
  };

}
