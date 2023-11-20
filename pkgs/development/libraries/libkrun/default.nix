{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, rustPlatform
, cargo
, pkg-config
, dtc
, glibc
, openssl
, libiconv
, libkrunfw
, rustc
, Hypervisor
, sevVariant ? false
}:

stdenv.mkDerivation rec {
  pname = "libkrun";
  version = "1.5.1";

  src = if stdenv.isLinux then fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-N9AkG+zkjQHNaaCVrEpMfWUN9bQNHjMA2xi5NUulF5A=";
  } else fetchurl {
    url = "https://github.com/containers/libkrun/releases/download/v${version}/v${version}-with_macos_prebuilts.tar.gz";
    hash = "sha256-8hPbnZtDbiVdwBrtxt4nZ/QA2OFtui2VsQlaoOmWybo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-nbtp7FP+ObVGfDOEzTt4Z7TZwcNlREczTKIAXGSflZU=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
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
    platforms = libkrunfw.meta.platforms;
    sourceProvenance = with sourceTypes; lib.optionals stdenv.isDarwin [ binaryNativeCode ];
  };
}
