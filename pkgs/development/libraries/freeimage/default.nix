{
  lib,
  stdenv,
  fetchsvn,
  darwin,
  libtiff,
  libpng,
  zlib,
  libwebp,
  libraw,
  openexr,
  openjpeg,
  libjpeg,
  jxrlib,
  pkg-config,
  fixDarwinDylibNames,
  autoSignDarwinBinariesHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freeimage";
  version = "unstable-2021-11-01";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/freeimage/svn/";
    rev = "1900";
    sha256 = "rWoNlU/BWKZBPzRb1HqU6T0sT7aK6dpqKPe88+o/4sA=";
  };

  sourceRoot = "${finalAttrs.src.name}/FreeImage/trunk";

  # Ensure that the bundled libraries are not used at all
  prePatch = ''
    rm -rf Source/Lib* Source/OpenEXR Source/ZLib
  '';
  patches = [
    ./unbundle.diff
    ./libtiff-4.4.0.diff
  ];

  postPatch =
    ''
      # To support cross compilation, use the correct `pkg-config`.
      substituteInPlace Makefile.fip \
        --replace "pkg-config" "$PKG_CONFIG"
      substituteInPlace Makefile.gnu \
        --replace "pkg-config" "$PKG_CONFIG"
    ''
    + lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
      # Upstream Makefile hardcodes i386 and x86_64 architectures only
      substituteInPlace Makefile.osx --replace "x86_64" "arm64"
    '';

  nativeBuildInputs =
    [
      pkg-config
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.cctools
      fixDarwinDylibNames
    ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
      autoSignDarwinBinariesHook
    ];
  buildInputs = [
    libtiff
    libtiff.dev_private
    libpng
    zlib
    libwebp
    libraw
    openexr
    openjpeg
    libjpeg
    libjpeg.dev_private
    jxrlib
  ];

  postBuild = lib.optionalString (!stdenv.isDarwin) ''
    make -f Makefile.fip
  '';

  INCDIR = "${placeholder "out"}/include";
  INSTALLDIR = "${placeholder "out"}/lib";

  preInstall =
    ''
      mkdir -p $INCDIR $INSTALLDIR
    ''
    # Workaround for Makefiles.osx not using ?=
    + lib.optionalString stdenv.isDarwin ''
      makeFlagsArray+=( "INCDIR=$INCDIR" "INSTALLDIR=$INSTALLDIR" )
    '';

  postInstall =
    lib.optionalString (!stdenv.isDarwin) ''
      make -f Makefile.fip install
    ''
    + lib.optionalString stdenv.isDarwin ''
      ln -s $out/lib/libfreeimage.3.dylib $out/lib/libfreeimage.dylib
    '';

  enableParallelBuilding = true;

  meta = {
    description = "Open Source library for accessing popular graphics image file formats";
    homepage = "http://freeimage.sourceforge.net/";
    license = "GPL";
    knownVulnerabilities = [
      "CVE-2021-33367"
      "CVE-2021-40262"
      "CVE-2021-40263"
      "CVE-2021-40264"
      "CVE-2021-40265"
      "CVE-2021-40266"

      "CVE-2023-47992"
      "CVE-2023-47993"
      "CVE-2023-47994"
      "CVE-2023-47995"
      "CVE-2023-47996"
    ];
    maintainers = with lib.maintainers; [
      viric
      l-as
    ];
    platforms = with lib.platforms; unix;
  };
})
