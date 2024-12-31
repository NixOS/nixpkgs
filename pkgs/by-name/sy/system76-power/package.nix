{
  pkg-config,
  libusb1,
  dbus,
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "system76-power";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-power";
    rev = version;
    hash = "sha256-Ju4xIWOf6m8z1fUSbzafKkyt9XXT8q1/8RukrhtswsE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dbus
    libusb1
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "sysfs-class-0.1.3" = "sha256-ztfwfCRAkxUd/LLNG5fpVuFdgX+tCKL3F35qYJ2GDm8=";
    };
  };

  postInstall = ''
    install -D -m 0644 data/com.system76.PowerDaemon.conf $out/etc/dbus-1/system.d/com.system76.PowerDaemon.conf
    install -D -m 0644 data/com.system76.PowerDaemon.policy $out/share/polkit-1/actions/com.system76.PowerDaemon.policy
    install -D -m 0644 data/com.system76.PowerDaemon.xml $out/share/dbus-1/interfaces/com.system76.PowerDaemon.xml
  '';

  meta = {
    description = "System76 Power Management";
    mainProgram = "system76-power";
    homepage = "https://github.com/pop-os/system76-power";
    license = lib.licenses.gpl3Plus;
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      smonson
      ahoneybun
    ];
  };
}
