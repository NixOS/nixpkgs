{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  libsodium,
  libiconv,
  pytestCheckHook,
  ansible-vault-rw,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "bittensor-wallet";
  version = "4.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "latent-to";
    repo = "btwallet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XjDldS3B3d9cR21M7HElqTAIyWjCdhSw1yBWHarVOcI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Dy9/yD/dT7cjKpM7S+h0iaXQUBnqYDMtQVZfIuaY1Ck=";
  };

  nativeBuildInputs = [
    pkg-config
  ]
  ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [
    openssl
    libsodium
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  nativeCheckInputs = [
    pytestCheckHook
    ansible-vault-rw
    setuptools
  ];

  # On darwin /tmp accesses are restricted inside the nix sandbox.
  # mock_wallet is part of the installed package and used by downstream packages' tests,
  # so it has to resolve a writable path at runtime.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace bittensor_wallet/mock/wallet_mock.py \
      --replace-fail 'import os' $'import os\nimport tempfile' \
      --replace-fail '"/tmp/mock_wallet"' 'tempfile.gettempdir() + "/mock_wallet"'
  '';

  preCheck = ''
    # remove source package so tests import the installed Rust extension
    rm -rf bittensor_wallet
    # ansible-vault writes to HOME
    export HOME=$(mktemp -d)
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    walletTestPath=$(mktemp -d)
    sed -i "s|/tmp/tests_wallets|$walletTestPath/tests_wallets|g" tests/test_wallet.py tests/test_keypair.py
  '';

  # test_common_calls.py requires bittensor, which depends on this package, which'd create a circular dependency
  disabledTestPaths = [ "tests/test_common_calls.py" ];

  pythonImportsCheck = [ "bittensor_wallet" ];

  meta = {
    description = "Bittensor wallet implementation";
    homepage = "https://github.com/latent-to/btwallet";
    changelog = "https://github.com/latent-to/btwallet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kilyanni ];
  };
})
