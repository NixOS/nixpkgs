{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cargo
, pkg-config
, glibc
, openssl
, libkrunfw
, rustc
, sevVariant ? false
}:

stdenv.mkDerivation rec {
  pname = "libkrun";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrun";
    rev = "refs/tags/v${version}";
    hash = "sha256-LIp2/794gbHPweBJcHCjbF0m+bJAs0SPF7WivW7fxLI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    hash = "sha256-g4ceYi16mjEgvWTAQEW8ShT/e5IKnlgLgk49Mg0N2fQ=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ] ++ lib.optionals sevVariant [
    pkg-config
  ];

  buildInputs = [
    (libkrunfw.override { inherit sevVariant; })
    glibc
    glibc.static
  ] ++ lib.optionals sevVariant [
    openssl
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ] ++ lib.optionals sevVariant [
    "SEV=1"
  ];

  meta = with lib; {
    description = "Dynamic library providing Virtualization-based process isolation capabilities";
    homepage = "https://github.com/containers/libkrun";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    platforms = libkrunfw.meta.platforms;
  };
}
