{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  autoreconfHook,
  libcap,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "torsocks";
  version = "2.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "core";
    repo = "torsocks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-um5D6d/fzKynfa1kA/VbdnKvAlZ7jQs+pmOgWQMpwgM=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  patches = [
    # tsocks_libc_accept4 only exists on Linux, use tsocks_libc_accept on other platforms
    (fetchpatch {
      url = "https://gitlab.torproject.org/tpo/core/torsocks/uploads/eeec9833512850306a42a0890d283d77/0001-Fix-macros-for-accept4-2.patch";
      hash = "sha256-XWi8+UFB8XgBFSl5QDJ+hLu/dH4CvAwYbeZz7KB10Bs=";
    })
    # no gethostbyaddr_r on darwin
    ./torsocks-gethostbyaddr-darwin.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace src/bin/torsocks.in --replace-fail \
    '"$(PATH="$PATH:/usr/sbin:/sbin" command -v getcap)"' '${libcap}/bin/getcap'
  '';

  doInstallCheck = true;
  installCheckTarget = "check-recursive";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://gitlab.torproject.org/tpo/core/torsocks/-/releases/v${finalAttrs.version}";
    description = "Wrapper to safely torify applications";
    homepage = "https://gitlab.torproject.org/tpo/core/torsocks";
    license = lib.licenses.gpl2Plus;
    mainProgram = "torsocks";
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = lib.platforms.unix;
  };
})
