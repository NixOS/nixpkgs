{
  lib,
  stdenv,
  buildPythonPackage,
  callPackage,
  setuptools,
  bcrypt,
  certifi,
  cffi,
  cryptography-vectors ? (callPackage ./vectors.nix { }),
  fetchFromGitHub,
  fetchpatch,
  isPyPy,
  libiconv,
  openssl,
  pkg-config,
  pretend,
  pytest-xdist,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "cryptography";
  version = "46.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyca";
    repo = "cryptography";
    tag = version;
    hash = "sha256-b6wQnPEf18ViqQVch+Jg1w0Cn372QKxLknD9rL4JjxY=";
  };

  # Fix installing stray files into site-packages
  patches = [
    (fetchpatch {
      url = "https://github.com/pyca/cryptography/commit/43eb178ee3aae8d0060221118437b03c23570a41.patch";
      hash = "sha256-dJkdt28Q0BrM2hNLcOD9f+RWTLelrZTPrm1NZG0HzN0=";
    })
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-5ElDEl7MdcQfu/hy+POSBcvkNCFAMo6La5s6uRhZ/fM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--benchmark-disable" ""
  '';

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    pkg-config
    setuptools
  ]
  ++ lib.optionals (!isPyPy) [ cffi ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  dependencies = lib.optionals (!isPyPy) [ cffi ];

  optional-dependencies.ssh = [ bcrypt ];

  nativeCheckInputs = [
    certifi
    cryptography-vectors
    pretend
    pytestCheckHook
    pytest-xdist
  ]
  ++ optional-dependencies.ssh;

  pytestFlags = [ "--disable-pytest-warnings" ];

  disabledTestPaths = [
    # save compute time by not running benchmarks
    "tests/bench"
  ];

  passthru = {
    vectors = cryptography-vectors;
  };

  meta = {
    description = "Package which provides cryptographic recipes and primitives";
    longDescription = ''
      Cryptography includes both high level recipes and low level interfaces to
      common cryptographic algorithms such as symmetric ciphers, message
      digests, and key derivation functions.
    '';
    homepage = "https://github.com/pyca/cryptography";
    changelog = "https://cryptography.io/en/latest/changelog/#v" + lib.replaceString "." "-" version;
    license = with lib.licenses; [
      asl20
      bsd3
      psfl
    ];
    maintainers = with lib.maintainers; [ mdaniels5757 ];
  };
}
