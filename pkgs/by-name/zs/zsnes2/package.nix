{
  lib,
  fetchFromGitHub,
  pkgsi686Linux,
}:

pkgsi686Linux.stdenv.mkDerivation (finalAttrs: {
  pname = "zsnes2";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "zsnes";
    tag = finalAttrs.version;
    hash = "sha256-jH1NoodprQlUSJHWz0gjM6LdgJtE6AvQ6/7hQQCUl5U=";
  };

  nativeBuildInputs = [
    pkgsi686Linux.nasm
    pkgsi686Linux.pkg-config
    pkgsi686Linux.python3
    pkgsi686Linux.udevCheckHook
  ];

  buildInputs = [
    (pkgsi686Linux.sdl3.overrideAttrs (oldAttrs: {
      doCheck = false;
    }))
    pkgsi686Linux.libGL
    pkgsi686Linux.libGLU
    pkgsi686Linux.libpng
    pkgsi686Linux.libx11
    pkgsi686Linux.zlib
  ];

  dontConfigure = true;

  env.NIX_CFLAGS_COMPILE = toString [
    # Until upstream fixes the issues...
    "-Wp,-D_FORTIFY_SOURCE=0"
  ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  postInstall = ''
    install -Dm644 linux/zsnes.desktop $out/share/applications/zsnes.desktop
    install -Dm644 icons/16x16x32.png $out/share/icons/hicolor/16x16/apps/zsnes.png
    install -Dm644 icons/32x32x32.png $out/share/icons/hicolor/32x32/apps/zsnes.png
    install -Dm644 icons/48x48x32.png $out/share/icons/hicolor/48x48/apps/zsnes.png
    install -Dm644 icons/64x64x32.png $out/share/icons/hicolor/64x64/apps/zsnes.png
  '';

  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/xyproto/zsnes";
    description = "Maintained fork of zsnes";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86;
  };
})
