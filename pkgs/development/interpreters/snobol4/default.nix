{
  lib,
  fetchurl,
  stdenv,
  bzip2,
  gdbm,
  gnum4,
  gzip,
  libffi,
  openssl,
  readline,
  sqlite,
  tcl,
  xz,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "snobol4";
  version = "2.3.2";

  src = fetchurl {
    urls = [
      "https://ftp.regressive.org/snobol4/snobol4-${version}.tar.gz"
      # fallback for when the current version is moved to the old folder
      "https://ftp.regressive.org/snobol4/old/snobol4-${version}.tar.gz"
    ];
    hash = "sha256-QeMB6d0YDXARfWTzaU+d1U+e2QmjajJYfIvthatorBU=";
  };

  outputs = [
    "out"
    "man"
    "doc"
  ];

  # gzip used by Makefile to compress man pages
  nativeBuildInputs = [
    gnum4
    gzip
  ];
  # enable all features (undocumented, based on manual review of configure script)
  buildInputs =
    [
      bzip2
      libffi
      openssl
      readline
      sqlite
      tcl
      xz
      zlib
    ]
    # ndbm compat library
    ++ lib.optional stdenv.isLinux gdbm;
  configureFlags = lib.optional (tcl != null) "--with-tcl=${tcl}/lib/tclConfig.sh";

  # INSTALL says "parallel make will fail"
  enableParallelBuilding = false;

  patches = [ ./fix-paths.patch ];

  # configure does not support --sbindir and the likes (as introduced by multiple-outputs.sh)
  # so man, doc outputs must be handled manually
  preConfigurePhases = [ "prePreConfigurePhase" ];
  prePreConfigurePhase = ''
    preConfigureHooks="''${preConfigureHooks//_multioutConfig/}"
    prependToVar configureFlags --mandir="$man"/share/man
  '';

  meta = with lib; {
    description = "Macro Implementation of SNOBOL4 in C";
    longDescription = ''
      An open source port of Macro SNOBOL4 (The original Bell Telephone Labs implementation, written in SIL macros) by Phil Budne.
      Supports full SNOBOL4 language plus SPITBOL, [Blocks](https://www.regressive.org/snobol4/blocks/) and other extensions.
    '';
    homepage = "https://www.regressive.org/snobol4/csnobol4/";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ xworld21 ];
  };
}
