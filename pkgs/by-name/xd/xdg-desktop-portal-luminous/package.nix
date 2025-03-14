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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xdg-desktop-portal-luminous";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "xdg-desktop-portal-luminous";
    tag = "v${finalAttrs.version}";
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

  env.LIBCLANG_PATH = "${lib.getLib libclang}/lib";

  configurePhase = ''
    runHook preConfigure

    meson build --prefix=$out --libdir=$out/lib --libexecdir=$out/libexec --buildtype=release

    runHook postConfigure
  '';

  ninjaFlags = [
    "-C"
    "build"
  ];

  meta = {
    description = "xdg-desktop-portal backend for wlroots based compositors, providing screenshot and screencast";
    homepage = "https://github.com/waycrate/xdg-desktop-portal-luminous";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Rishik-Y ];
  };
})
