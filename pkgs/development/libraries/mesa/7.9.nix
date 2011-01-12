{ stdenv, fetchurl, pkgconfig, x11, xlibs, libdrm, expat, lipo ? null,
  talloc, python, libxml2, libxml2Python}:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

stdenv.mkDerivation rec {
  version = "7.9";
  name = "mesa-${version}";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/${version}/MesaLib-${version}.tar.bz2";
    sha256 = "1wr927mdghn7w1cmp0bxswjda5s2x0hwfpf8zcc9x03da7s6gkg0";
  };

  configureFlags =
    "--disable-gallium"
    + (if stdenv.system == "mips64-linux" then
      " --with-dri-drivers=swrast --with-driver=dri" else "")
    + (if stdenv.isDarwin then " --disable-egl" else "");

  buildInputs =
    [ pkgconfig expat x11 libdrm xlibs.glproto
      xlibs.libXxf86vm xlibs.libXfixes xlibs.libXdamage xlibs.dri2proto
      lipo talloc python libxml2 libxml2Python
    ];

  passthru = { inherit libdrm; };

  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = "bsd";
  };
}
