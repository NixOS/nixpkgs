{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  freetype,
  wafHook,
  python3,
  libxmu,
  glew,
  ucs-fonts,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zutty";
  version = "0.18-unstable-2026-11-16";

  src = fetchgit {
    url = "https://git.hq.sig7.se/zutty.git";
    rev = "e19e0264eb6adf5f6205d324917d5a1a057c84a9";
    hash = "sha256-3o3kXhGBwFDhi7VJdFgNGUCjDfdlPVvM2WyRMu/Jv40=";
  };

  postPatch =
    let
      fontpaths = [
        "/run/current-system/sw/share/X11/fonts" # available if fonts.fontDir.enable = true
        "${ucs-fonts}/share/fonts"
      ];
    in
    ''
      substituteInPlace src/options.h \
        --replace-fail /usr/share/fonts ${builtins.concatStringsSep ":" fontpaths}
    '';

  nativeBuildInputs = [
    pkg-config
    wafHook
    python3
  ];

  buildInputs = [
    freetype
    libxmu
    glew
  ];

  passthru = {
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      default = nixosTests.terminal-emulators.zutty;
    };
  };

  meta = {
    homepage = "https://tomscii.sig7.se/zutty/";
    description = "X terminal emulator rendering through OpenGL ES Compute Shaders";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.rolfschr ];
    platforms = lib.platforms.linux;
  };
})
