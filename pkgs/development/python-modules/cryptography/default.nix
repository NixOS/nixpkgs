{ lib, stdenv
, buildPythonPackage
, fetchPypi
, rustPlatform
, setuptools-rust
, openssl
, cryptography_vectors
, darwin
, packaging
, six
, isPyPy
, cffi
, pytest
, pytest-subtests
, pretend
, libiconv
, iso8601
, pytz
, hypothesis
}:

buildPythonPackage rec {
  pname = "cryptography";
  version = "36.0.0"; # Also update the hash in vectors.nix

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zshc1jaavykdnic5ns8zax6gqganys6gp5f35bqcfggnkn6kxsj";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
    sha256 = "1nbw4cfshyc125jwdivg9gxy52qcd1iz31lypl95ij9bn1dyx933";
  };

  cargoRoot = "src/rust";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = lib.optionals (!isPyPy) [
    cffi
  ] ++ [
    rustPlatform.cargoSetupHook
    setuptools-rust
  ] ++ (with rustPlatform; [ rust.cargo rust.rustc ]);

  buildInputs = [ openssl ]
             ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security libiconv ];
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

  pytestFlags = lib.concatStringsSep " " ([
    "--disable-pytest-warnings"
  ] ++
    lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
      # aarch64-darwin forbids W+X memory, but this tests depends on it:
      # * https://cffi.readthedocs.io/en/latest/using.html#callbacks
      "--ignore=tests/hazmat/backends/test_openssl_memleak.py"
    ]
  );

  checkPhase = ''
    py.test ${pytestFlags} tests
  '';

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
