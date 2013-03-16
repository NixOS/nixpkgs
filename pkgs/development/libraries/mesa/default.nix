{ stdenv, fetchurl, flex, bison, pkgconfig, intltool, libdrm, file, expat, makedepend
, libXxf86vm, libXfixes, libXdamage, glproto, dri2proto, libX11, libxcb, libXext
, libXt, udev, enableTextureFloats ? false, enableR600LlvmCompiler ? false
, python, libxml2Python, autoconf, automake, libtool, llvm, writeText
, wayland }:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

let
  version = "9.1";
in
stdenv.mkDerivation {
  name = "mesa-${version}";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/${version}/MesaLib-${version}.tar.bz2";
    sha256="0yvhl0vdg32h0xr4xi348gkp0hlcc16j1cfxn4pyc9pywyzlqj5g";
  };

  prePatch = "patchShebangs .";

  preConfigure = "./autogen.sh";

  configureFlags =
    ""
    + " --enable-gles1 --enable-gles2 --enable-gallium-egl"
    + " --with-gallium-drivers=i915,nouveau,r300,r600,svga,swrast"
    + " --with-egl-platforms=x11,wayland,drm --enable-gbm --enable-shared-glapi"
    + stdenv.lib.optionalString enableR600LlvmCompiler " --enable-r600-llvm-compiler"
    # Texture floats are patented, see docs/patents.txt
    + stdenv.lib.optionalString enableTextureFloats " --enable-texture-float";

  buildInputs = [
    autoconf automake libtool intltool expat libxml2Python udev llvm
    libdrm libXxf86vm libXfixes libXdamage glproto dri2proto libX11 libXext libxcb libXt
    wayland
  ];

  nativeBuildInputs = [ pkgconfig python makedepend file flex bison ];

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
