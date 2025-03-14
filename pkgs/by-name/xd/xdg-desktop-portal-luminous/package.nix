{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  libclang,
  clang,
  xdg-desktop-portal,
  slurp,
  cairo,
  pango,
  libxkbcommon,
  glib,
  pipewire,
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-luminous";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7i6+arKWubziDmy07FocDDiJdOWAszhO7yOOI1iPfds=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fatlvc+MoAJZGW/5alnDu1PQyK6mnE0aNQAhrMg7Hio=";

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    clang
    libclang
  ];
  buildInputs = [
    xdg-desktop-portal
    slurp
    cairo
    pango
    glib
    pipewire
    libxkbcommon
  ];

  LIBCLANG_PATH = "${libclang.lib}/lib";

  configurePhase = ''
    meson build --prefix=$out --libexecdir=$out/lib --buildtype=release
  '';

  buildPhase = ''
    ninja -C build
  '';

  installPhase = ''
    ninja -C build install
  '';

  meta = with lib; {
    description = "xdg-desktop-portal backend for wlroots based compositors, providing screenshot and screencast";
    homepage = "https://github.com/waycrate/xdg-desktop-portal-luminous";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ Rishik-Y ];
  };
}
