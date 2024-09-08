{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cargo
, pkg-config
, glibc
, openssl
, libepoxy
, libdrm
, pipewire
, virglrenderer
, libkrunfw
, llvmPackages
, rustc
, withGpu ? false
, withSound ? false
, withNet ? false
, sevVariant ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkrun";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrun";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-QzyNPThwbjPKANeZ4GAT9b4f8LTcjXnCiK+vzRkhM4c=";
  };

  outputs = [ "out" "dev" ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-33s62iOWYh1a8ETY/fbPRxvnj8dR4/UfG8mjFyWwz5k=";
  };

  nativeBuildInputs = [
    llvmPackages.clang
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ] ++ lib.optional (sevVariant || withGpu) pkg-config;

  buildInputs = [
    (libkrunfw.override { inherit sevVariant; })
    glibc
    glibc.static
  ] ++ lib.optionals withGpu [ libepoxy libdrm virglrenderer ]
    ++ lib.optional withSound pipewire
    ++ lib.optional sevVariant openssl;

  env.LIBCLANG_PATH = "${llvmPackages.clang-unwrapped.lib}/lib/libclang.so";

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ] ++ lib.optional withGpu "GPU=1"
    ++ lib.optional withSound "SND=1"
    ++ lib.optional withNet "NET=1"
    ++ lib.optional sevVariant "SEV=1";

  postInstall = ''
    mkdir -p $dev/lib/pkgconfig
    mv $out/lib64/pkgconfig $dev/lib/pkgconfig
    mv $out/include $dev/include
  '';

  meta = with lib; {
    description = "Dynamic library providing Virtualization-based process isolation capabilities";
    homepage = "https://github.com/containers/libkrun";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao RossComputerGuy ];
    platforms = libkrunfw.meta.platforms;
  };
})
