{
  lib,
  buildGo122Module,
  fetchFromGitHub,
  gtk4,
  gtk4-layer-shell,
  gobject-introspection,
  pkg-config,
}:

buildGo122Module rec {
  pname = "walker";
  version = "0.0.18";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "walker";
    rev = "v${version}";
    hash = "sha256-CVCor9KZbyDfudGtBhwBWphZrOEsjZ7WUpcXhOM4ek0=";
  };

  vendorHash = "sha256-mey6LyBKWhSlrjSztMHOX+g/fqlX3yvVIa6Rfgt6t/k=";

  buildInputs = [
    gtk4
    gtk4-layer-shell
    gobject-introspection
  ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Wayland-native application runner";
    homepage = "https://github.com/abenz1267/walker";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "walker";
  };
}
