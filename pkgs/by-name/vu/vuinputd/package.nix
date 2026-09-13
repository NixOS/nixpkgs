{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fuse3,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vuinputd";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "joleuger";
    repo = "vuinputd";
    tag = finalAttrs.version;
    hash = "sha256-X9uGLz86k0RveCasi/sjBwCy5xZAcGAOQWnOYD1VZWE=";
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock

    # error[E0425]: cannot find type `libfuse_version` in this scope
    # (see https://github.com/joleuger/vuinputd/pull/8)
    substituteInPlace cuse-lowlevel/build.rs --replace-fail \
      '.blocklist_function("fuse_set_log_func");' \
      '.blocklist_function("fuse_set_log_func").allowlist_type("^libfuse_version$");'
  '';

  cargoBuildFlags = [
    "-p"
    "vuinputd"
  ];
  cargoInstallFlags = [
    "-p"
    "vuinputd"
  ];

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];
  buildInputs = [
    fuse3
    udev
  ];

  doCheck = false;

  postInstall = ''
    # systemd
    install -Dm644 $src/vuinputd/systemd/vuinputd.service $out/etc/systemd/system/vuinputd.service
    substituteInPlace $out/etc/systemd/system/vuinputd.service \
      --replace-fail /usr/local/bin/vuinputd $out/bin/vuinputd

    # udev
    install -Dm444 $src/vuinputd/udev/90-vuinputd-protect.rules $out/etc/udev/rules.d/90-vuinputd-protect.rules
    install -Dm644 $src/vuinputd/udev/90-vuinputd.hwdb $out/etc/udev/hwdb.d/90-vuinputd.hwdb
  '';

  meta = with lib; {
    description = "Container-safe mediation daemon for /dev/uinput";
    homepage = "https://github.com/joleuger/vuinputd";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "vuinputd";
    maintainers = with maintainers; [ griffi-gh ];
  };
})
