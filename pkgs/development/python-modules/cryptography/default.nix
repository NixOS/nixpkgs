{ lib, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, rustPlatform
, setuptools-rust
, openssl
, cryptography_vectors
, darwin
, packaging
, six
, pythonOlder
, isPyPy
, cffi
, pytest
, pytest-subtests
, pretend
, iso8601
, pytz
, hypothesis
}:

buildPythonPackage rec {
  pname = "cryptography";
  version = "3.4.6"; # Also update the hash in vectors.nix

  src = fetchPypi {
    inherit pname version;
    sha256 = "11wgsihfq72fav67c3igi0xbhbd6c5dj869byd1jkq0fbcz24cid";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
    sha256 = "1i0sd2y4a5g1yqwcpw2ycp6p4p8sk5v7clblq756i5864j52v6w1";
  };

  cargoRoot = "src/rust";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = lib.optionals (!isPyPy) [
    cffi
    rustPlatform.cargoSetupHook
    setuptools-rust
  ] ++ (with rustPlatform; [ rust.cargo rust.rustc ]);

  buildInputs = [ openssl ]
             ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;
  propagatedBuildInputs = [
    packaging
    six
  ] ++ lib.optionals (!isPyPy) [
    cffi
  ];

  checkInputs = [
    cryptography_vectors
    hypothesis
    iso8601
    pretend
    pytest
    pytest-subtests
    pytz
  ];

  checkPhase = ''
    py.test --disable-pytest-warnings tests
  '';

  # IOKit's dependencies are inconsistent between OSX versions, so this is the best we
  # can do until nix 1.11's release
  __impureHostDeps = [ "/usr/lib" ];

  meta = with lib; {
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
