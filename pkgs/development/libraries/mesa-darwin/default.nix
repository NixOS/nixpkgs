{ stdenv, fetchurl, pkgconfig, intltool, flex, bison
, python, libxml2Python, expat, makedepend, xorg, llvm, libffi, libvdpau
, OpenGL, apple_sdk, Xplugin
}:

let
  version = "8.0.5";
  self = stdenv.mkDerivation rec {
    name = "mesa-${version}";

    src =  fetchurl {
      url = "ftp://ftp.freedesktop.org/pub/mesa/older-versions/8.x/${version}/MesaLib-${version}.tar.bz2";
      sha256 = "0pjs8x51c0i6mawgd4w03lxpyx5fnx7rc8plr8jfsscf9yiqs6si";
    };

    nativeBuildInputs = [ pkgconfig python makedepend flex bison ];

    buildInputs = with xorg; [
      glproto dri2proto libXfixes libXi libXmu
      intltool expat libxml2Python llvm
      presentproto
      libX11 libXext libxcb libXt libxshmfence
      libffi libvdpau
    ] ++ stdenv.lib.optionals stdenv.isDarwin [ OpenGL apple_sdk.sdk Xplugin ];

    propagatedBuildInputs = stdenv.lib.optionals stdenv.isDarwin [ OpenGL ];

    postUnpack = ''
      ln -s darwin $sourceRoot/configs/current
    '';

    preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace bin/mklib --replace g++ clang++
    '';

    patches = [
      ./patches/0003-mesa-fix-per-level-max-texture-size-error-checking.patch
      ./patches/0008-glsl-initialise-const-force-glsl-extension-warning-i.patch
      ./patches/0009-mesa-test-for-GL_EXT_framebuffer_sRGB-in-glPopAttrib.patch
      ./patches/0011-Apple-glFlush-is-not-needed-with-CGLFlushDrawable.patch
      ./patches/0012-glapi-Avoid-heap-corruption-in-_glapi_table.patch
      ./patches/0013-darwin-Fix-test-for-kCGLPFAOpenGLProfile-support-at-.patch
      ./patches/1001-appleglx-Improve-error-reporting-if-CGLChoosePixelFo.patch
      ./patches/1002-darwin-Write-errors-in-choosing-the-pixel-format-to-.patch
      ./patches/1003-darwin-Guard-Core-Profile-usage-behind-a-testing-env.patch
      ./patches/patch-src-mapi-vgapi-Makefile.diff
    ];

    postPatch = "patchShebangs .";

    configurePhase = ":";

    configureFlags = [
      # NOTE: Patents expired on June 17 2018.
      # For details see: https://www.phoronix.com/scan.php?page=news_item&px=OpenGL-Texture-Float-Freed
      "texture-float"
    ];

    makeFlags = "INSTALL_DIR=\${out} CC=cc CXX=c++";

    enableParallelBuilding = true;

    passthru = { inherit version; };

    meta = {
      description = "An open source implementation of OpenGL";
      homepage = http://www.mesa3d.org/;
      license = "bsd";
      platforms = stdenv.lib.platforms.darwin;
      maintainers = with stdenv.lib.maintainers; [ cstrahan ];
    };
  };
in self // { driverLink = self; }
