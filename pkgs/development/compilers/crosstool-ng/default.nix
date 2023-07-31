{ lib
, stdenv
, fetchurl
, fetchpatch
, autoconf
, automake
, binutils
, bison
, flex
, gnum4
, help2man
, libtool
, makeWrapper
, ncurses
, perl
, python3
, texinfo
, unzip
, wget
, which
}:

stdenv.mkDerivation rec {
  pname = "crosstool-ng";
  version = "1.25.0";

  src = fetchurl {
    url = "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${version}.tar.xz";
    sha256 = "sha256-aBYvNCJDzUGJ7XwfTjuxMCyqPyy7+DMYeb0B/gbGDNM=";
  };

  patches = [
    # fix zlib download error
    # remove in next release
    (
      fetchpatch {
        name = "fix-zlib-download.patch";
        url = "https://github.com/crosstool-ng/crosstool-ng/commit/878a16a13af1024356f2aa623ef7419ec82d4d76.patch";
        sha256 = "sha256-yiui/i4JSEnR8G4fBydTpdI5yw8f6G6XiwuA3Axy4c4=";
      }
    )
  ];

  nativeBuildInputs = [
    # remove in next release
    autoconf
    automake

    binutils
    bison
    flex
    help2man
    libtool
    makeWrapper
    ncurses
    python3
    texinfo
    unzip
    wget
    which
  ];

  preConfigure = ''
    # let crosstool-ng find zlib 1.2.13
    # remove in next release
    patchShebangs .
    touch packages/zlib/1.2.13/version.desc
    ./bootstrap
  '';

  postInstall = ''
    # add runtime dependencies to build toolchain
    wrapProgram "$out/bin/ct-ng" \
      --prefix PATH : ${lib.makeBinPath [ wget gnum4 which perl autoconf automake python3 binutils ]}
  '';

  # binutils interfere with code signing on darwin
  dontStrip = stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://crosstool-ng.github.io/";
    description = "A versatile (cross-)toolchain generator";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jiegec ];
    platforms = platforms.unix;
  };
}

