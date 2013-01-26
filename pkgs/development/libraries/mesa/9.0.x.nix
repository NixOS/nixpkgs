{ stdenv, fetchurl, autoconf, automake, autoreconfHook, libtool
, flex, bison, pkgconfig, libdrm2_4_40, file, expat, makedepend, llvm
, libXxf86vm, libXfixes, libXdamage, glproto, dri2proto, libX11, libxcb, libXext
, libXt, udev, enableTextureFloats ? false
, python, libxml2Python, wayland }:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

let version = "9.0.2"; in

stdenv.mkDerivation {
  name = "mesa-${version}";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/${version}/MesaLib-${version}.tar.bz2";
    md5 = "dc45d1192203e418163e0017640e1cfc";
  };

  patches =
    stdenv.lib.optional (stdenv.system == "mips64el-linux") ./mips_wmb.patch;

  prePatch = "patchShebangs .";

  configureFlags =
      " --enable-gles1 --enable-gles2 --disable-gallium-egl"
    + " --with-egl-platforms=x11,wayland,drm --enable-gbm --enable-shared-glapi"
    + " --with-gallium-drivers=i915,nouveau,r600,svga,swrast"
    # Texture floats are patented, see docs/patents.txt
    + stdenv.lib.optionalString enableTextureFloats " --enable-texture-float";

  buildInputs = [ autoconf automake autoreconfHook libtool
    expat libdrm2_4_40 libXxf86vm libXfixes libXdamage glproto dri2proto llvm
    libxml2Python libX11 libXext libxcb libXt udev wayland ];

  buildNativeInputs = [ pkgconfig python makedepend file flex bison ];

  enableParallelBuilding = true;

  passthru = { inherit libdrm2_4_40; };

  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = "bsd";
    platforms = stdenv.lib.platforms.mesaPlatforms;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
