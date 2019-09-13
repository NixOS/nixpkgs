{ stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, openssl
, cryptography_vectors
, darwin
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
  pname = "cryptography";
  version = "2.7"; # Also update the hash in vectors.nix

  src = fetchPypi {
    inherit pname version;
    sha256 = "1inlnr36kl36551c9rcad99jmhk81v33by3glkadwdcgmi17fd76";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ openssl ]
             ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;
  propagatedBuildInputs = [
    asn1crypto
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

  patches = [
    (fetchpatch {
      url = "https://github.com/pyca/cryptography/commit/e575e3d482f976c4a1f3203d63ea0f5007a49a2a.patch";
      sha256 = "0vg9prqsizd6gzh5j7lscsfxzxlhz7pacvzhgqmj1vhdhjwbblcp";
    })
  ];

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
