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
  version = "1.4.8";

  src = if stdenv.isLinux then fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3oNsY91hgor1nZV10mcEZyEdhmHlozF8xXaCR4dvLYg=";
  } else fetchurl {
    url = "https://github.com/containers/libkrun/releases/download/v${version}/v${version}-with_macos_prebuilts.tar.gz";
    hash = "sha256-eKjBUianpW4T8OeVwRSEyZFfDE10d3qogkPA4FUJ7rc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-9v8UaBBpQDPZwHVurFJ1FaFMe6wywH3upKDjGcPYnuQ=";
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
