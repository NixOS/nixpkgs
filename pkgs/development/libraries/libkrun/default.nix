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
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrun";
    rev = "refs/tags/v${version}";
    hash = "sha256-R8JofaoqEM6IL4mr10kOWH0GfqwuyG2qkFjGR1+0fXw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    hash = "sha256-gPWTFl5YrlWDBXyksc9TidOzQf42bSJ05pdqtErk844=";
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
