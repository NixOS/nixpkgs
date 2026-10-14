{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  libGL,
  vulkan-loader,
  wayland,
  libxkbcommon,
  libx11,
  libxcursor,
  libxrandr,
  libxi,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "x1ctl";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Fexiven";
    repo = "x1ctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MtwbJfJm0jjPn2Tm7U7AT4NzEbbjfnvISVB1yGRbejA=";
  };

  cargoHash = "sha256-yYAeJRAfbc0dHvgqrRlQBcxN6OV7xs3oOzxZQIMhsek=";

  buildFeatures = [ "gui" ];
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    install -Dm644 packaging/70-sound-blaster-x1.rules -t $out/lib/udev/rules.d
    install -Dm644 packaging/x1d.service packaging/x1-tray.service -t $out/lib/systemd/user
    install -Dm644 packaging/io.github.x1ctl.service -t $out/share/dbus-1/services
    install -Dm644 packaging/io.github.x1ctl.X1Gui.desktop -t $out/share/applications
    install -Dm644 packaging/io.github.x1ctl.X1Gui.svg -t $out/share/icons/hicolor/scalable/apps
    substituteInPlace $out/lib/systemd/user/*.service $out/share/dbus-1/services/*.service \
      --replace-fail /usr/bin/ $out/bin/
  '';

  # egui loads GL/Vulkan, Wayland and X11 with dlopen
  postFixup = ''
    wrapProgram $out/bin/x1-gui --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
        libxkbcommon
        libx11
        libxcursor
        libxrandr
        libxi
      ]
    }
  '';

  meta = {
    description = "Control daemon, CLI and GUI for the Creative Sound Blaster X1";
    homepage = "https://github.com/Fexiven/x1ctl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fexiven ];
    mainProgram = "x1ctl";
    platforms = lib.platforms.linux;
  };
})
