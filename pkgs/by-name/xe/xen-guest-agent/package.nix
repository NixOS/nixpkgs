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
  version = "0.4.0-unstable-2024-05-31";

  src = fetchFromGitLab {
    owner = "xen-project";
    repo = pname;
    rev = "03aaadbe030f303b1503e172ee2abb6d0cab7ac6";
    hash = "sha256-OhzRsRwDvt0Ov+nLxQSP87G3RDYSLREMz2w9pPtSUYg=";
  };

  cargoHash = "sha256-E6QKh4FFr6sLAByU5n6sLppFwPHSKtKffhQ7FfdXAu4=";

  nativeBuildInputs = [
    llvmPackages.clang
    pkg-config
  ];

  buildInputs = [ xen-slim ];

  env.LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

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
