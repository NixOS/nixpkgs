{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, makeFontsConf
, nix-update-script
, autoreconfHook
, pkg-config
, perl
, unittest-cpp
, xa
, libgcrypt
, libexsid
, docSupport ? true
, doxygen
, graphviz
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsidplayfp";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "libsidplayfp";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-1e1QDSJ8CjLU794saba2auCKko7p2ylrdI0JWhh8Kco=";
  };

  patches = [
    # Pull autoconf-2.72 compatibility fix:
    #   https://github.com/libsidplayfp/libsidplayfp/pull/103
    (fetchpatch {
      name = "autoconf-2.72";
      url = "https://github.com/libsidplayfp/libsidplayfp/commit/b8fff55f6aaa005a3899b59e70cd8730f962641b.patch";
      hash = "sha256-5Hk202IuHUBow7HnnPr2/ieWFjKDuHLQjQ9mJUML9q8=";
    })
  ];

  postPatch = ''
    patchShebangs .
  '';

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook pkg-config perl xa ]
    ++ lib.optionals docSupport [ doxygen graphviz ];

  buildInputs = [ libgcrypt libexsid ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkInputs = [ unittest-cpp ];

  enableParallelBuilding = true;

  installTargets = [ "install" ]
    ++ lib.optionals docSupport [ "doc" ];

  outputs = [ "out" ]
    ++ lib.optionals docSupport [ "doc" ];

  configureFlags = [
    "--enable-hardsid"
    "--with-gcrypt"
    "--with-exsid"
  ]
  ++ lib.optional finalAttrs.finalPackage.doCheck "--enable-tests";

  FONTCONFIG_FILE = lib.optionalString docSupport (makeFontsConf { fontDirectories = [ ]; });

  preBuild = ''
    # Reduce noise from fontconfig during doc building
    export XDG_CACHE_HOME=$TMPDIR
  '';

  postInstall = lib.optionalString docSupport ''
    mkdir -p $doc/share/doc/libsidplayfp
    mv docs/html $doc/share/doc/libsidplayfp/
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A library to play Commodore 64 music derived from libsidplay2";
    longDescription = ''
      libsidplayfp is a C64 music player library which integrates
      the reSID SID chip emulation into a cycle-based emulator
      environment, constantly aiming to improve emulation of the
      C64 system and the SID chips.
    '';
    homepage = "https://github.com/libsidplayfp/libsidplayfp";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ ramkromberg OPNA2608 ];
    platforms = platforms.all;
  };
})
