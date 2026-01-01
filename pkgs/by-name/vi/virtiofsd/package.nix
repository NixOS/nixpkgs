{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitLab,
  libcap_ng,
  libseccomp,
<<<<<<< HEAD
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "virtiofsd";
  version = "1.13.3";
=======
}:

rustPlatform.buildRustPackage rec {
  pname = "virtiofsd";
  version = "1.13.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    owner = "virtio-fs";
    repo = "virtiofsd";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-H8FjnrwB6IfZ7pVFesEWZkWpWjVYGrewlPRZc97Nlh8=";
=======
    rev = "v${version}";
    hash = "sha256-7ShmdwJaMjaUDSFnzHnsTQ/CmAQ0qpZnX5D7cFYHNmo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  separateDebugInfo = true;

<<<<<<< HEAD
  cargoHash = "sha256-AOWHlvFvKj05f4/KE1F37qkRstW5gUlRH0HZVZrg7Dg=";
=======
  cargoHash = "sha256-Y07SJ54sw4CPCPq/LoueGBfHuZXu9F32yqMR6LBJ09I=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    homepage = "https://gitlab.com/virtio-fs/virtiofsd";
    changelog = "https://gitlab.com/virtio-fs/virtiofsd/-/releases/v${finalAttrs.version}";
    description = "vhost-user virtio-fs device backend written in Rust";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    homepage = "https://gitlab.com/virtio-fs/virtiofsd";
    description = "vhost-user virtio-fs device backend written in Rust";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      qyliss
      astro
    ];
    mainProgram = "virtiofsd";
<<<<<<< HEAD
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
=======
    platforms = platforms.linux;
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      asl20 # and
      bsd3
    ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
