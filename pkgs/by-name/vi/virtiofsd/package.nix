{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitLab,
  libcap_ng,
  libseccomp,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "virtiofsd";
  version = "1.13.3";

  src = fetchFromGitLab {
    owner = "virtio-fs";
    repo = "virtiofsd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-H8FjnrwB6IfZ7pVFesEWZkWpWjVYGrewlPRZc97Nlh8=";
  };

  separateDebugInfo = true;

  cargoHash = "sha256-AOWHlvFvKj05f4/KE1F37qkRstW5gUlRH0HZVZrg7Dg=";

  LIBCAPNG_LIB_PATH = "${lib.getLib libcap_ng}/lib";
  LIBCAPNG_LINK_TYPE = if stdenv.hostPlatform.isStatic then "static" else "dylib";

  buildInputs = [
    libcap_ng
    libseccomp
  ];

  postConfigure = ''
    sed -i "s|/usr/libexec|$out/bin|g" 50-virtiofsd.json
  '';

  postInstall = ''
    install -Dm644 50-virtiofsd.json "$out/share/qemu/vhost-user/50-virtiofsd.json"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    homepage = "https://gitlab.com/virtio-fs/virtiofsd";
    changelog = "https://gitlab.com/virtio-fs/virtiofsd/-/releases/v${finalAttrs.version}";
    description = "vhost-user virtio-fs device backend written in Rust";
    maintainers = with lib.maintainers; [
      qyliss
      astro
    ];
    mainProgram = "virtiofsd";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      asl20 # and
      bsd3
    ];
  };
})
