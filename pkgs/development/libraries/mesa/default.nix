{ stdenv, fetchurl, flex, bison, pkgconfig, libdrm, file, expat, makedepend
, libXxf86vm, libXfixes, libXdamage, glproto, dri2proto, libX11, libxcb, libXext
, libXt, udev, enableTextureFloats ? false
, python, libxml2Python, lipo ? null }:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

let version = "7.11.2"; in

stdenv.mkDerivation {
  name = "mesa-${version}";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/${version}/MesaLib-${version}.tar.bz2";
    sha256 = "0msk1fh4yw4yi7z37v75vhpa23z49lkwgin6drczbihbqsl6lx2p";
  };

  patches = [ ./swrast-settexbuffer.patch ];

  prePatch = "patchShebangs .";

# r300
  configureFlags =
      " --with-driver=dri --enable-gl-osmesa --enable-gles1"
    + " --with-gallium-drivers=i915,i965,nouveau,r600,svga,swrast"
    + " --enable-gles2 --enable-gallium-egl --disable-glx-tls"
    + " --enable-xcb --enable-egl --disable-glut"
    # Texture floats are patented, see docs/patents.txt
    + stdenv.lib.optionalString enableTextureFloats " --enable-texture-float";

  buildInputs = [ expat libdrm libXxf86vm libXfixes libXdamage glproto dri2proto
    libxml2Python libX11 libXext libxcb lipo libXt udev ];

  buildNativeInputs = [ pkgconfig python makedepend file flex bison ];

  enableParallelBuilding = true;

  passthru = { inherit libdrm; };

  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = "bsd";

    platforms = stdenv.lib.platforms.mesaPlatforms;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
