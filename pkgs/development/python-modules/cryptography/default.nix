{ stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, isPy27
, ipaddress
, openssl
, cryptography_vectors
, darwin
, packaging
, six
, pythonOlder
, isPyPy
, cffi
, pytest
, pretend
, iso8601
, pytz
, hypothesis
, enum34
}:

buildPythonPackage rec {
  pname = "cryptography";
  version = "2.9.2"; # Also update the hash in vectors.nix

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0c30272fb4ddda5f5ffc1089d7405b7a71b0b0f51993cb4e5dbb4590b2fc229";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ openssl ]
             ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;
  propagatedBuildInputs = [
    packaging
    six
  ] ++ stdenv.lib.optional (!isPyPy) cffi
  ++ stdenv.lib.optionals isPy27 [ ipaddress enum34 ];

  checkInputs = [
    cryptography_vectors
    hypothesis
    iso8601
    pretend
    pytest
    pytz
  ];

  checkPhase = ''
    py.test --disable-pytest-warnings tests
  '';

  # IOKit's dependencies are inconsistent between OSX versions, so this is the best we
  # can do until nix 1.11's release
  __impureHostDeps = [ "/usr/lib" ];

  meta = with stdenv.lib; {
    description = "A package which provides cryptographic recipes and primitives";
    longDescription = ''
      Cryptography includes both high level recipes and low level interfaces to
      common cryptographic algorithms such as symmetric ciphers, message
      digests, and key derivation functions.
      Our goal is for it to be your "cryptographic standard library". It
      supports Python 2.7, Python 3.5+, and PyPy 5.4+.
    '';
    homepage = "https://github.com/pyca/cryptography";
    changelog = "https://cryptography.io/en/latest/changelog/#v"
      + replaceStrings [ "." ] [ "-" ] version;
    license = with licenses; [ asl20 bsd3 psfl ];
    maintainers = with maintainers; [ primeos ];
  };
}
