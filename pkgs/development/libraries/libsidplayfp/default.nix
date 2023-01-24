{ stdenv
, lib
, fetchFromGitHub
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
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "libsidplayfp";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-stfpyJC1AVmDh1Nk5c5Lv0j6ic2AU6mwY02L/IDr8tE=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config perl xa ]
    ++ lib.optionals docSupport [ doxygen graphviz ];

  buildInputs = [ libgcrypt libexsid ];

  doCheck = true;

  nativeCheckInputs = [ unittest-cpp ];

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
