{ stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, openssl
, cryptography_vectors
, darwin
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
  pname = "cryptography";
  version = "2.8"; # Also update the hash in vectors.nix

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l8nhw14npknncxdnp7n4hpmjyscly6g7fbivyxkjwvlv071zniw";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ openssl ]
             ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;
  propagatedBuildInputs = [
    packaging
    six
  ] ++ stdenv.lib.optional (pythonOlder "3.4") enum34
  ++ stdenv.lib.optional (pythonOlder "3.3") ipaddress
  ++ stdenv.lib.optional (!isPyPy) cffi;

  checkInputs = [
    cryptography_vectors
    hypothesis
    iso8601
    pretend
    pytest
    pytz
  ];

  # remove when https://github.com/pyca/cryptography/issues/4998 is fixed
  checkPhase = ''
    py.test --disable-pytest-warnings tests -k 'not load_ecdsa_no_named_curve'
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
      supports Python 2.7, Python 3.4+, and PyPy 5.3+.
    '';
    homepage = https://github.com/pyca/cryptography;
    license = with licenses; [ asl20 bsd3 psfl ];
    maintainers = with maintainers; [ primeos ];
  };
}
