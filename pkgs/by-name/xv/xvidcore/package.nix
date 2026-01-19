{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  yasm,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xvidcore";
  version = "1.3.7";

  src = fetchurl {
    url = "https://downloads.xvid.com/downloads/${finalAttrs.pname}-${finalAttrs.version}.tar.bz2";
    hash = "sha256-ruqulS1Ns5UkmDmjvQOEHWhEhD9aT4TCcf+I96oaz/c=";
  };

  patches = [
    # Fix build with gcc15
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/xvidcore/raw/95382dbe529e5589a727fffceb620b0a89ff55f2/f/xvidcore-c23.patch";
      hash = "sha256-bGwWNmXIEIIw4Tc7lrMZ4jnhcQ+uKAsxL6fuAOosMVA=";
    })
  ];

  preConfigure = ''
    # Configure script is not in the root of the source directory
    cd build/generic
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Undocumented darwin hack
    substituteInPlace configure --replace "-no-cpp-precomp" ""
  '';

  configureFlags =
    [ ]
    # Undocumented darwin hack (assembly is probably disabled due to an
    # issue with nasm, however yasm is now used)
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "--enable-macosx_module"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isFreeBSD) [
      "--disable-assembly"
    ];

  nativeBuildInputs = [ ] ++ lib.optional (!stdenv.hostPlatform.isDarwin) yasm;

  buildInputs =
    [ ]
    # Undocumented darwin hack
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      autoconf
      automake
      libtool
    ];

  # Don't remove static libraries (e.g. 'libs/*.a') on darwin.  They're needed to
  # compile ffmpeg (and perhaps other things).
  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    rm $out/lib/*.a
  '';

  # Dependants of xvidcore don't know to look in bin for dependencies. Link them
  # in lib so other depedants of xvidcore can find the dlls.
  postFixup = lib.optionalString stdenv.hostPlatform.isMinGW ''
    ln -s $out/bin/*.dll $out/lib
  '';

  meta = {
    description = "MPEG-4 video codec for PC";
    homepage = "https://www.xvid.com/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      codyopel
      lovek323
    ];
    platforms = lib.platforms.all;
  };
})
