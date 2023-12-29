{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, makeFontsConf
, nix-update-script
, testers
, autoreconfHook
, docSupport ? true
, doxygen
, graphviz
, libexsid
, libgcrypt
, perl
, pkg-config
, unittest-cpp
, xa
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

  outputs = [
    "out"
  ] ++ lib.optionals docSupport [
    "doc"
  ];

  patches = [
    # Pull autoconf-2.72 compatibility fix:
    #   https://github.com/libsidplayfp/libsidplayfp/pull/103
    # Remove when version > 2.5.1
    (fetchpatch {
      name = "0001-libsidplayfp-autoconf-2.72-compat.patch";
      url = "https://github.com/libsidplayfp/libsidplayfp/commit/2b1b41beb5099d5697e3f8416d78f27634732a9e.patch";
      hash = "sha256-5Hk202IuHUBow7HnnPr2/ieWFjKDuHLQjQ9mJUML9q8=";
    })

    # Fix --disable-tests logic
    # https://github.com/libsidplayfp/libsidplayfp/pull/108
    # Remove when version > 2.5.1
    (fetchpatch {
      name = "0002-libsidplayfp-Fix-autoconf-logic-for-tests-option.patch";
      url = "https://github.com/libsidplayfp/libsidplayfp/commit/39dd2893b6186c4932d17b529bb62627b742b742.patch";
      hash = "sha256-ErdfPvu8R81XxdHu2TaV87OpLFlRhJai51QcYUIkUZ4=";
    })
  ];

  postPatch = ''
    patchShebangs .
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
    xa
  ] ++ lib.optionals docSupport [
    doxygen
    graphviz
  ];

  buildInputs = [
    libexsid
    libgcrypt
  ];

  checkInputs = [
    unittest-cpp
  ];

  enableParallelBuilding = true;

  configureFlags = [
    (lib.strings.enableFeature true "hardsid")
    (lib.strings.withFeature true "gcrypt")
    (lib.strings.withFeature true "exsid")
    (lib.strings.enableFeature finalAttrs.finalPackage.doCheck "tests")
  ];

  # Make Doxygen happy with the setup, reduce log noise
  FONTCONFIG_FILE = lib.optionalString docSupport (makeFontsConf { fontDirectories = [ ]; });

  preBuild = ''
    # Reduce noise from fontconfig during doc building
    export XDG_CACHE_HOME=$TMPDIR
  '';

  buildFlags = [
    "all"
  ] ++ lib.optionals docSupport [
    "doc"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postInstall = lib.optionalString docSupport ''
    mkdir -p $doc/share/doc/libsidplayfp
    mv docs/html $doc/share/doc/libsidplayfp/
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
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
    pkgConfigModules = [
      "libsidplayfp"
      "libstilview"
    ];
  };
})
