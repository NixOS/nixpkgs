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
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrun";
    rev = "refs/tags/v${version}";
    hash = "sha256-cP+Pxl/9QIsoGysXTBZJ86q57cIMA7TJenMWtcOI+Y4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    hash = "sha256-qVyHC015QJEt6LZ8br3H0nucYKhYGBMtyB2IBaixTqk=";
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
    description = "A dynamic library providing Virtualization-based process isolation capabilities";
    homepage = "https://github.com/containers/libkrun";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    platforms = libkrunfw.meta.platforms;
  };
}
