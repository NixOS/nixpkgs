{ lib
, buildPythonPackage
, fetchPypi
, pkg-config
, rustPlatform
, cargo
, rustc
, bzip2
, nettle
, openssl
, pcsclite
, stdenv
, darwin
, libiconv
}:

buildPythonPackage rec {
  pname = "pysequoia";
  version = "0.1.20";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KavsLp17e4ckX11B0pefiQ1Hma/O9x0VY/uVPiJm4Fs=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-7Lw6gR6o2HJ/zyG4b0wz4nmU2AIIAhyK9zaQ6w+/RgE=";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  buildInputs = [
    bzip2
    nettle
    openssl
    pcsclite
  ] ++ lib.optionals stdenv.isDarwin [
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
    broken = stdenv.isDarwin;
  };
}
