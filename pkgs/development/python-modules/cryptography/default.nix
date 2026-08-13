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
  fetchpatch2,
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
  version = "48.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyca";
    repo = "cryptography";
    tag = version;
    hash = "sha256-S1oOLou6tE1atqZ6HXwVQDps9BnjiEpRdoZY5VQm+Kg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-mp+1Fw8xNBJD1DM8obAqYBP8erxXiP768+ifqRN1Uqs=";
  };

  patches = [
    # CVE-2026-69247
    (fetchpatch2 {
      url = "https://github.com/pyca/cryptography/commit/53fccd93413a8d7f07d6d8999681f27b75cffa3f.patch?full_index=1";
      excludes = [ "CHANGELOG.rst" ];
      hash = "sha256-BBMsnFozpIJCkRejCYZrfiEikLJSJXCAMCBqa5vRL5E=";
    })
    # CVE-2026-69248
    (fetchpatch2 {
      url = "https://github.com/pyca/cryptography/commit/4d035a4225965edeffd312079a510ef25fcfdcb2.patch?full_index=1";
      excludes = [ ".github/actions/**" ];
      hash = "sha256-Uct2j+kMYVJ0PJ0WtPqQkACVFyqKjK4bi5LMuRHWCZo=";
    })
    # CVE-2026-69249
    (fetchpatch2 {
      url = "https://github.com/pyca/cryptography/commit/4a12cf49675a184e47f912b00b04f3a629283582.patch?full_index=1";
      excludes = [ ".github/actions/**" ];
      hash = "sha256-9WFoA+H/OMLLkSfJvhBf9cgSYrhuVokYKLr6WeNJAgI=";
    })
  ];

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
