{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  libiconv,
  nettle,
  pcsclite,
  pkg-config,
  pytestCheckHook,
  rustPlatform,
  tzdata,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "johnnycanencrypt";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kushaldas";
    repo = "johnnycanencrypt";
    tag = "v${version}";
    hash = "sha256-qpta6D5aslUwuJ0+voYrHFIDetlsUB6PkScrtl/plVs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-EzHbV/IBbGjoKFIbXSo2dlf+DU7ZXV16bVR93Sq0lis=";
  };

  build-system = with rustPlatform; [
    bindgenHook
    cargoSetupHook
    maturinBuildHook
  ];

  nativeBuildInputs = [
    pkg-config
  ]
  ++ (with rustPlatform; [
    bindgenHook
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [
    nettle
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pcsclite ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  dependencies = [
    httpx
    tzdata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
  ];

  preCheck = ''
    # import from $out
    rm -r johnnycanencrypt
  '';

  pythonImportsCheck = [ "johnnycanencrypt" ];

  meta = {
    description = "Python module for OpenPGP written in Rust";
    homepage = "https://github.com/kushaldas/johnnycanencrypt";
    changelog = "https://github.com/kushaldas/johnnycanencrypt/blob/v${version}/changelog.md";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ _0x4A6F ];
  };
}
