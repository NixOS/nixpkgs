{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
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
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "libsidplayfp";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0487gap2b0ypikyra74lk1qwqwr0vncldamk5xb1db2x97v504fd";
  };

  # https://github.com/libsidplayfp/libsidplayfp/issues/13
  # Remove on next version bump
  patches = [
    (fetchpatch {
      url = "https://github.com/libsidplayfp/libsidplayfp/commit/84f5498f5653261ed84328e1b5676c31e3ba9e6e.patch";
      sha256 = "1vysbl4fkdzm11k40msng2ag6i6mb6z9jsw32vyj9calcfha5957";
    })
    (fetchpatch {
      url = "https://github.com/libsidplayfp/libsidplayfp/commit/c1a1b732cc2e791d910522d58f47c6d094493c6d.patch";
      sha256 = "1d3sgdly0q9dysgkx5afxbwfas6p0m8n3lw1hmj4n6wm3j9sdz4g";
    })
  ];

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config perl xa ]
    ++ lib.optionals docSupport [ doxygen graphviz ];

  buildInputs = [ libgcrypt libexsid ];

  doCheck = true;

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
  ++ lib.optional doCheck "--enable-tests";

  postInstall = lib.optionalString docSupport ''
    mkdir -p $doc/share/doc/libsidplayfp
    mv docs/html $doc/share/doc/libsidplayfp/
  '';

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
