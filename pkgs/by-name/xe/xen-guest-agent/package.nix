{
  lib,
  fetchFromGitLab,
  rustPlatform,
  llvmPackages,
  pkg-config,
  xen-slim,
}:
rustPlatform.buildRustPackage rec {
  pname = "xen-guest-agent";
  version = "0.4.0";

  src = fetchFromGitLab {
    owner = "xen-project";
    repo = pname;
    rev = version;
    hash = "sha256-kJSXF/iXH0VU3sp7yOfGw6kuQPNuueQVqIk0u/OrZqk=";
  };

  cargoHash = "sha256-JsL9/kDsVFx/AC0FXbBLvk9r7Q+daL8lvqli1fE0OE8=";

  env = {
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
    PKG_CONFIG_PATH = "${xen-slim.dev}/lib/pkgconfig";
    BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${xen-slim.dev}/include";
    RUSTFLAGS = "-L ${xen-slim.out}/lib";
  };

  nativeBuildInputs = [
    llvmPackages.clang
    pkg-config
    xen-slim.out
  ];

  postFixup = ''
    patchelf $out/bin/xen-guest-agent --add-rpath ${xen-slim.out}/lib
  '';

  meta = {
    description = "Xen agent running in Linux/BSDs (POSIX) VMs";
    homepage = "https://gitlab.com/xen-project/xen-guest-agent";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      matdibu
      sigmasquadron
    ];
  };
}
