{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
  gtk3,
  pkg-config,
}:
buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "waybar-niri-windows";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "calico32";
    repo = "waybar-niri-windows";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bnPxKRugnIGj/Od8R+6PAl0MRhhl361H9rYydCWQ/yw=";
  };

  vendorHash = "sha256-jK87vZYfUe8znk65SmJ1mN8qP5K3dtt950hKGWTYXs4=";

  buildInputs = [
    gtk3
  ];
  nativeBuildInputs = [
    pkg-config
  ];

  # use custom command because when setting GOFLAGS evaluation fails, but .so file is needed
  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/lib
    mv waybar-niri-windows.so $out/lib
    ln -s $out/lib/waybar-niri-windows.so $out/lib/plugin.so
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Niri window minimap/focus indicator for Waybar";
    homepage = "https://github.com/calico32/waybar-niri-windows";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ istudyatuni ];
  };
})
