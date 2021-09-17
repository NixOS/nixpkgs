{ lib, stdenv, fetchsvn, darwin, libtiff
, libpng, zlib, libwebp, libraw, openexr, openjpeg
, libjpeg, jxrlib, pkg-config
, fixDarwinDylibNames }:

stdenv.mkDerivation {
  pname = "freeimage";
  version = "unstable-2020-07-04";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/freeimage/svn/";
    rev = "1859";
    sha256 = "1d94935aqbkb994nqkw7m8xcynyz9rm6k7k59igrbjak8b63qpi6";
  };
  sourceRoot = "svn-r1859/FreeImage/trunk";

  # Ensure that the bundled libraries are not used at all
  prePatch = "rm -rf Source/Lib* Source/OpenEXR Source/ZLib";
  patches = [ ./unbundle.diff ];

  postPatch = ''
    # To support cross compilation, use the correct `pkg-config`.
    substituteInPlace Makefile.fip \
      --replace "pkg-config" "$PKG_CONFIG"
    substituteInPlace Makefile.gnu \
      --replace "pkg-config" "$PKG_CONFIG"
  '';

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.cctools
    fixDarwinDylibNames
  ];
  buildInputs = [ libtiff libtiff.dev_private libpng zlib libwebp libraw openexr openjpeg libjpeg libjpeg.dev_private jxrlib ];

  postBuild = lib.optionalString (!stdenv.isDarwin) ''
    make -f Makefile.fip
  '';

  INCDIR = "${placeholder "out"}/include";
  INSTALLDIR = "${placeholder "out"}/lib";

  preInstall = ''
    mkdir -p $INCDIR $INSTALLDIR
  ''
  # Workaround for Makefiles.osx not using ?=
  + lib.optionalString stdenv.isDarwin ''
    makeFlagsArray+=( "INCDIR=$INCDIR" "INSTALLDIR=$INSTALLDIR" )
  '';

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    make -f Makefile.fip install
  '' + lib.optionalString stdenv.isDarwin ''
    ln -s $out/lib/libfreeimage.3.dylib $out/lib/libfreeimage.dylib
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Open Source library for accessing popular graphics image file formats";
    homepage = "http://freeimage.sourceforge.net/";
    license = "GPL";
    maintainers = with lib.maintainers; [viric l-as];
    platforms = with lib.platforms; unix;
  };
}
