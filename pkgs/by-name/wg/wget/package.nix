{
  lib,
  stdenv,
  fetchurl,

  gettext,
  pkg-config,
  perlPackages,
  libidn2,
  zlib,
  pcre2,
  libuuid,
  libiconv,
  libintl,
  nukeReferences,
  python3,
  lzip,

  withLibpsl ? false,
  libpsl,

  withOpenssl ? true,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "wget";
  version = "1.25.0";

  src = fetchurl {
    url = "mirror://gnu/wget/wget-${version}.tar.lz";
    hash = "sha256-GSJcx1awoIj8gRSNxqQKDI8ymvf9hIPxx7L+UPTgih8=";
  };

  preConfigure = ''
    patchShebangs doc
  '';

  nativeBuildInputs = [
    gettext
    pkg-config
    perlPackages.perl
    lzip
    nukeReferences
  ];
  buildInputs =
    [
      libidn2
      zlib
      pcre2
      libuuid
      libiconv
      libintl
    ]
    ++ lib.optional withOpenssl openssl
    ++ lib.optional withLibpsl libpsl
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      perlPackages.perl
    ];

  strictDeps = true;

  configureFlags =
    [
      (lib.withFeatureAs withOpenssl "ssl" "openssl")
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # https://lists.gnu.org/archive/html/bug-wget/2021-01/msg00076.html
      "--without-included-regex"
    ];

  preBuild = ''
    # avoid runtime references to build-only depends
    make -C src version.c
    nuke-refs src/version.c
  '';

  enableParallelBuilding = true;

  __darwinAllowLocalNetworking = true;
  doCheck = true;
  preCheck =
    ''
      patchShebangs tests fuzz

      # Work around lack of DNS resolution in chroots.
      for i in "tests/"*.pm "tests/"*.px
      do
        sed -i "$i" -e's/localhost/127.0.0.1/g'
      done
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # depending on the underlying filesystem, some tests
      # creating exotic file names fail
      for f in tests/Test-ftp-iri.px \
        tests/Test-ftp-iri-fallback.px \
        tests/Test-ftp-iri-recursive.px \
        tests/Test-ftp-iri-disabled.px \
        tests/Test-iri-disabled.px \
        tests/Test-iri-list.px ;
      do
        # just return magic "skip" exit code 77
        sed -i 's/^exit/exit 77 #/' $f
      done
    '';

  nativeCheckInputs =
    [
      perlPackages.HTTPDaemon
      python3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      perlPackages.IOSocketSSL
    ];

  meta = {
    description = "Tool for retrieving files using HTTP, HTTPS, and FTP";
    homepage = "https://www.gnu.org/software/wget/";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      GNU Wget is a free software package for retrieving files using HTTP,
      HTTPS and FTP, the most widely-used Internet protocols.  It is a
      non-interactive commandline tool, so it may easily be called from
      scripts, cron jobs, terminals without X-Windows support, etc.
    '';
    mainProgram = "wget";
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.all;
  };
}
