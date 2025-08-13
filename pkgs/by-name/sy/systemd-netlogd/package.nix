{
  lib,
  stdenv,
  fetchFromGitHub,
  gperf,
  libcap,
  meson,
  ninja,
  nix-update-script,
  openssl,
  pkg-config,
  pkgsCross,
  sphinx,
  systemd,
  systemdLibs,
  testers,
  opensslSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "systemd-netlogd";
  version = "1.4.4";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "systemd-netlogd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kgr6KZp2SSLG8xnqXNWsDgIa9rNnBGcN+TkuAbr+yAA=";
  };

  # Fixup a few installation paths
  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "get_option('prefix')" "get_option('bindir')"
    substituteInPlace doc/meson.build \
      --replace-fail "'/usr/share/man/man8'" "get_option('mandir') / 'man8'"
    substituteInPlace units/meson.build \
      --replace-fail "get_option('prefix') / 'system'" "get_option('libdir') / 'systemd/system'"

    substituteInPlace units/systemd-netlogd.service.in \
      --replace-fail '@PKGPREFIX@/systemd-netlogd' '${placeholder "out"}/bin/systemd-netlogd'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    gperf
    meson
    ninja
    pkg-config
    sphinx
  ];

  buildInputs = [
    libcap
    systemdLibs
  ]
  ++ lib.optional opensslSupport openssl;

  mesonFlags = [
    "--sysconfdir=${placeholder "out"}/etc/systemd"
    (lib.mesonBool "openssl" opensslSupport)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    # Make sure x86_64-linux -> aarch64-linux cross compilation works
    tests = {
      version = testers.testVersion { package = finalAttrs.finalPackage; };
    }
    // lib.optionalAttrs (stdenv.buildPlatform.system == "x86_64-linux") {
      aarch64-cross = pkgsCross.aarch64-multiplatform.systemd-netlogd;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Forwards messages from the journal to other hosts over the network";
    homepage = "https://github.com/systemd/systemd-netlogd";
    changelog = "https://github.com/systemd/systemd-netlogd/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "systemd-netlogd";
    inherit (systemd.meta) platforms;
  };
})
