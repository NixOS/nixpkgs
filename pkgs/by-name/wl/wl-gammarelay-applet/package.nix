{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  wayland,
  libxkbcommon,
  fontconfig,
  pkg-config,
  autoPatchelfHook,
}:

rustPlatform.buildRustPackage {
  pname = "wl-gammarelay-applet";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "lgbishop";
    repo = "wl-gammarelay-applet";
    rev = "8a0d9e6364d7445fc69c59b2f168cfec91c2fe87";
    sha256 = "sha256-t6bycmaquZ0IMs/WnAzkz5FnIWKIq0BTbeeoUFLeuYg=";
  };

  cargoHash = "sha256-1hJLu/ndnBYdzJ+NjLaCYENFszvAj9MYpLsZyLEq0Sg=";

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  runtimeDependencies = [
    wayland
    libxkbcommon
    fontconfig.lib
  ];

  meta = {
    description = "Control wl-gammarelay-rs via applet";
    longDescription = ''
      wl-gammarelay-applet is a small desktop applet for controlling
      wl-gammarelay-rs via DBus. This applet is written in Rust and
      provides a Slint UI.
    '';
    homepage = "https://github.com/lgbishop/wl-gammarelay-applet";
    mainProgram = "wl-gammarelay-applet";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lgbishop ];
  };
}
