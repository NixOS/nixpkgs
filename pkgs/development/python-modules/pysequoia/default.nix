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
  libiconv,
}:

buildPythonPackage rec {
  pname = "pysequoia";
  version = "0.1.26";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ip4yv54e1c+zshEtLVgK5D2VcB41AzSEJHuD5t8akXI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-vm9PpJHRznxNVtL28PBGnQcMUHwFn5uxW7Y9UufAUPg=";
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
      libiconv
    ];

  pythonImportsCheck = [ "pysequoia" ];

  meta = with lib; {
    description = "This library provides OpenPGP facilities in Python through the Sequoia PGP library";
    downloadPage = "https://codeberg.org/wiktor/pysequoia";
    homepage = "https://sequoia-pgp.gitlab.io/pysequoia";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
