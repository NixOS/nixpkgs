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

let
  version = "2.1.4";
in assert version == cryptography_vectors.version; buildPythonPackage rec {
  # also bump cryptography_vectors
  pname = "cryptography";
  inherit version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e4d967371c5b6b2e67855066471d844c5d52d210c36c28d49a8507b96e2c5291";
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

  # The test assumes that if we're on Sierra or higher, that we use `getentropy`, but for binary
  # compatibility with pre-Sierra for binary caches, we hide that symbol so the library doesn't
  # use it. This boils down to them checking compatibility with `getentropy` in two different places,
  # so let's neuter the second test.
  postPatch = ''
    substituteInPlace ./tests/hazmat/backends/test_openssl.py --replace '"16.0"' '"99.0"'
  '';

  # IOKit's dependencies are inconsistent between OSX versions, so this is the best we
  # can do until nix 1.11's release
  __impureHostDeps = [ "/usr/lib" ];
}