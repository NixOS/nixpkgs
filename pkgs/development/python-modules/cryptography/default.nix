{ stdenv
, buildPythonPackage
, fetchPypi
, openssl
, cryptography_vectors
, darwin
, idna
, asn1crypto
, packaging
, six
, pythonOlder
, enum34
, ipaddress
, isPyPy
, cffi
, pytest
, pretend
, iso8601
, pytz
, hypothesis
}:

buildPythonPackage rec {
  # also bump cryptography_vectors
  pname = "cryptography";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d10113ca826a4c29d5b85b2c4e045ffa8bad74fb525ee0eceb1d38d4c70dfd6";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ openssl cryptography_vectors ]
             ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;
  propagatedBuildInputs = [
    idna
    asn1crypto
    packaging
    six
  ] ++ stdenv.lib.optional (pythonOlder "3.4") enum34
  ++ stdenv.lib.optional (pythonOlder "3.3") ipaddress
  ++ stdenv.lib.optional (!isPyPy) cffi;

  checkInputs = [
    pytest
    pretend
    iso8601
    pytz
    hypothesis
  ];

  checkPhase = ''
    py.test --disable-pytest-warnings tests
  '';

  # IOKit's dependencies are inconsistent between OSX versions, so this is the best we
  # can do until nix 1.11's release
  __impureHostDeps = [ "/usr/lib" ];
}
