{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, glibc
, openssl
, libkrunfw
, sevVariant ? false
}:

stdenv.mkDerivation rec {
  pname = "libkrun";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qVyEqiqaQ8wfZhL5u+Bsaa1yXlgHUitSj5bo7FJ5Y8c=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-jxSzhj1iU8qY+sZEVCYTaUqpaA4egjJi9qxrapASQF0=";
  };

  nativeBuildInputs = with rustPlatform;[
    cargoSetupHook
    rust.cargo
    rust.rustc
  ] ++ lib.optional sevVariant pkg-config;

  buildInputs = [
    glibc
    glibc.static
    (libkrunfw.override { inherit sevVariant; })
  ] ++ lib.optional sevVariant openssl;

  makeFlags = [ "PREFIX=${placeholder "out"}" ]
    ++ lib.optional sevVariant "SEV=1";

  meta = with lib; {
    description = "A dynamic library providing Virtualization-based process isolation capabilities";
    homepage = "https://github.com/containers/libkrun";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
