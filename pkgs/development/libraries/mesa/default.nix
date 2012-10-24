{ stdenv, fetchurl, autoconf, automake, libtool, flex, bison, pkgconfig, libdrm, file, expat, makedepend
, llvm
, libXxf86vm, libXfixes, libXdamage, glproto, dri2proto, libX11, libxcb, libXext
, libXt, udev, enableTextureFloats ? false
, python, libxml2Python }:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

let version = "9.0"; in

stdenv.mkDerivation {
  name = "mesa-${version}";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/${version}/MesaLib-${version}.tar.bz2";
    md5 = "60e557ce407be3732711da484ab3db6c";
  };

  patches =
    stdenv.lib.optional (stdenv.system == "mips64el-linux") ./mips_wmb.patch;

  prePatch = "patchShebangs .";

  configureFlags =
      " --enable-gles1 --enable-gles2 --enable-gallium-egl"
    + " --with-gallium-drivers=i915,nouveau,r600,svga,swrast"
    # Texture floats are patented, see docs/patents.txt
    + stdenv.lib.optionalString enableTextureFloats " --enable-texture-float";

  buildInputs = [ autoconf automake libtool expat libdrm libXxf86vm libXfixes libXdamage glproto dri2proto
    llvm
    libxml2Python libX11 libXext libxcb libXt udev ];

  buildNativeInputs = [ pkgconfig python makedepend file flex bison ];

  preConfigure = "./autogen.sh";

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
