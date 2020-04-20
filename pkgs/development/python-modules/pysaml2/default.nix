{ stdenv
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, fetchpatch
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
    # remove on next release
    (fetchpatch {
      name = "fix-test-dates.patch";
      url = "https://github.com/IdentityPython/pysaml2/commit/1d97d2d26f63e42611558fdd0e439bb8a7496a27.patch";
      sha256 = "0r6d6hkk6z9yw7aqnsnylii516ysmdsc8dghwmgnwvw6cm7l388p";
    })
  ];

  postPatch = ''
    # fix failing tests on systems with 32bit time_t
    sed -i 's/2999\(-.*T\)/2029\1/g' tests/*.xml
  '';

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
