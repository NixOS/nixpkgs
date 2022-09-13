{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, rustPlatform
, pkg-config
, dtc
, glibc
, openssl
, libiconv
, libkrunfw
, Hypervisor
, sevVariant ? false
}:

stdenv.mkDerivation rec {
  pname = "libkrun";
  version = "1.3.0";

  src = if stdenv.isLinux then fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qVyEqiqaQ8wfZhL5u+Bsaa1yXlgHUitSj5bo7FJ5Y8c=";
  } else fetchurl {
    url = "https://github.com/containers/libkrun/releases/download/v${version}/v${version}-with_macos_prebuilts.tar.gz";
    hash = "sha256-RBqeGUhB6Sdt+JujyQBW/76mZwnT0LNs9AMYr8+OCVU=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-jxSzhj1iU8qY+sZEVCYTaUqpaA4egjJi9qxrapASQF0=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ] ++ lib.optional sevVariant pkg-config;

  buildInputs = [
    (libkrunfw.override { inherit sevVariant; })
  ] ++ lib.optionals stdenv.isLinux [
    glibc
    glibc.static
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    Hypervisor
    dtc
  ] ++ lib.optional sevVariant openssl;

  makeFlags = [ "PREFIX=${placeholder "out"}" ]
    ++ lib.optional sevVariant "SEV=1";

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/libkrun.dylib $out/lib/libkrun.${version}.dylib
  '';

  meta = with lib; {
    description = "A dynamic library providing Virtualization-based process isolation capabilities";
    homepage = "https://github.com/containers/libkrun";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
