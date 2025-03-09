{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pipewire,
  pkg-config,
  bcc,
  dbus,
}:

let
  version = "2.0.2";
in
rustPlatform.buildRustPackage {
  pname = "system76-scheduler";
  inherit version;
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-scheduler";
    rev = version;
    hash = "sha256-5GiHmu++YRCewDHm/qxKmQwDIAZwlW5Eya/fDriVSdA=";
  };
  cargoHash = "sha256-HxNqGe+KrmOoLgaKY9pniPWFF/hehSi1dgZn4LPE7OA=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];
  buildInputs = [
    dbus
    pipewire
  ];

  EXECSNOOP_PATH = "${bcc}/bin/execsnoop";

  # tests don't build
  doCheck = false;

  postInstall = ''
    mkdir -p $out/data
    install -D -m 0644 data/com.system76.Scheduler.conf $out/etc/dbus-1/system.d/com.system76.Scheduler.conf
    install -D -m 0644 data/*.kdl $out/data/
  '';

  meta = with lib; {
    description = "System76 Scheduler";
    mainProgram = "system76-scheduler";
    homepage = "https://github.com/pop-os/system76-scheduler";
    license = licenses.mpl20;
    platforms = [
      "x86_64-linux"
      "x86-linux"
      "aarch64-linux"
    ];
    maintainers = [ maintainers.cmm ];
  };
}
