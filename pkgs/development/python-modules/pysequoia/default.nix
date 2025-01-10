{
  lib,
  buildPythonPackage,
  fetchPypi,
  pkg-config,
  rustPlatform,
  cargo,
  rustc,
  bzip2,
  nettle,
  openssl,
  pcsclite,
  stdenv,
  darwin,
  libiconv,
}:

buildPythonPackage rec {
  pname = "pysequoia";
  version = "0.1.24";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sLGPVyUVh1MxAJz8933xGAxaI9+0L/D6wViy5ARLe44=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-DLMAL1pJwJ5xU9XzJXlrqfNGloK9VNGxnapnh34bRhI=";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  buildInputs =
    [
      bzip2
      nettle
      openssl
      pcsclite
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
      libiconv
    ];

  pythonImportsCheck = [ "pysequoia" ];

  meta = with lib; {
    description = "This library provides OpenPGP facilities in Python through the Sequoia PGP library";
    downloadPage = "https://codeberg.org/wiktor/pysequoia";
    homepage = "https://sequoia-pgp.gitlab.io/pysequoia";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
    # Broken since the 0.1.20 update according to ofborg. The errors are not clear...
    broken = stdenv.hostPlatform.isDarwin;
  };
}
