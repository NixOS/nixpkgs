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
  version = "2.0.2-unstable-2026-07-22";
in
rustPlatform.buildRustPackage {
  pname = "system76-scheduler";
  inherit version;
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-scheduler";
    rev = "8651bbf74bcfc8a46443b30199b380e12defa97e";
    hash = "sha256-V8NGJzlWvhnd5LPCjOfaB/eIXGFJDZWYhQYov1RDxkw=";
  };

  cargoHash = "sha256-+heUUihZaETojlyrl+nul3/KuXG88WxRzNXVgsVvaFA=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];
  buildInputs = [
    dbus
    pipewire
  ];

  env.EXECSNOOP_PATH = "${bcc}/bin/execsnoop";

  # tests don't build
  doCheck = false;

  postInstall = ''
    mkdir -p $out/data
    install -D -m 0644 data/com.system76.Scheduler.conf $out/etc/dbus-1/system.d/com.system76.Scheduler.conf
    install -D -m 0644 data/*.kdl $out/data/
  '';

  meta = {
    description = "System76 Scheduler";
    mainProgram = "system76-scheduler";
    homepage = "https://github.com/pop-os/system76-scheduler";
    license = lib.licenses.mpl20;
    platforms = [
      "x86_64-linux"
      "x86-linux"
      "aarch64-linux"
    ];
    maintainers = [ lib.maintainers.cmm ];
  };
}
