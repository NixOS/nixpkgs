{
  lib,
  rustPlatform,
  pkg-config,
  wayland,
  dbus,
  backend,
  src,
  version,
}:

rustPlatform.buildRustPackage {
  pname = "t3code-${backend}-snap-shot";
  inherit src version;

  sourceRoot = "${src.name}/native/${backend}-snap-shot";
  cargoHash =
    {
      kde = "sha256-ZbetrRAvnNLLS51IwR9xLb1NhnpFQB4J1ahn4CthJy0=";
      hyprland = "sha256-oki1DAzUJ/8YIFhaJlw2wOukiQMcAaexdJqxDcFXFW4=";
    }
    .${backend};

  nativeBuildInputs = lib.optionals (backend == "hyprland") [ pkg-config ];
  buildInputs = lib.optionals (backend == "hyprland") [ wayland ];
  nativeCheckInputs = lib.optionals (backend == "kde") [ dbus ];

  postPatch = lib.optionalString (backend == "kde") ''
    # The tests start a private bus; /etc/dbus-1 is absent in the sandbox.
    substituteInPlace src/transport_tests.rs \
      --replace-fail '"--session"' '"--config-file=${dbus}/share/dbus-1/session.conf"'
  '';

  postInstall = lib.optionalString (backend == "hyprland") ''
    # The protocol XML files contain the notices required for redistribution.
    mkdir -p "$out/share/t3code/hyprland-capture"
    cp -r protocols "$out/share/t3code/hyprland-capture/"
  '';

  meta = {
    description = "Native ${backend} window capture helper for T3 Code";
    homepage = "https://github.com/pingdotgg/t3code";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "t3-${backend}-snap-shot";
  };
}
