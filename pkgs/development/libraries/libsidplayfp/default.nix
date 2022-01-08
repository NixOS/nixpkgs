{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
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
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "libsidplayfp";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-Cu5mZzsqAO4X4Y8QAn851zIFPVPwxj5pB+jvA62L108=";
  };

  patches = [
    # Fixes test failure on x86_64-darwin
    # Drop when fix for https://github.com/libsidplayfp/libsidplayfp/issues/39 in a release (>2.3.1)
    (fetchpatch {
      url = "https://github.com/libsidplayfp/libsidplayfp/commit/337020a91caa0113de4f4374e0dc770e4056d2c7.patch";
      sha256 = "0sd7bqic8k945f05d8sk9mshf5d90ykd7f5p6m0n6v3jjhpwmqlq";
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

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
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
