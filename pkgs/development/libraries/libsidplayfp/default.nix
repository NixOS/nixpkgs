{ stdenv
, lib
, fetchFromGitHub
<<<<<<< HEAD
, makeFontsConf
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

stdenv.mkDerivation rec {
  pname = "libsidplayfp";
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "libsidplayfp";
    rev = "v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    sha256 = "sha256-KCp/8UjVl8e3+4s1FD4GvHP7AUAS+eIB7RWhmgm5GIA=";
=======
    sha256 = "sha256-e+blEdO2KA/noW9pq56qZ0/vvtqQwiDbBJoQR0cQeds=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    patchShebangs .
  '';

<<<<<<< HEAD
  strictDeps = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ autoreconfHook pkg-config perl xa ]
    ++ lib.optionals docSupport [ doxygen graphviz ];

  buildInputs = [ libgcrypt libexsid ];

<<<<<<< HEAD
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkInputs = [ unittest-cpp ];
=======
  doCheck = true;

  nativeCheckInputs = [ unittest-cpp ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
  ++ lib.optional doCheck "--enable-tests";

<<<<<<< HEAD
  FONTCONFIG_FILE = lib.optionalString docSupport (makeFontsConf { fontDirectories = [ ]; });

  preBuild = ''
    # Reduce noise from fontconfig during doc building
    export XDG_CACHE_HOME=$TMPDIR
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
}
