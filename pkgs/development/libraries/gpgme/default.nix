{ stdenv, fetchurl, fetchpatch, libgpgerror, gnupg, pkgconfig, glib, pth, libassuan
, qtbase ? null }:

let inherit (stdenv) lib system; in

stdenv.mkDerivation rec {
  name = "gpgme-${version}";
  version = "1.11.1";

  src = fetchurl {
    url = "mirror://gnupg/gpgme/${name}.tar.bz2";
    sha256 = "0vxx5xaag3rhp4g2arp5qm77gvz4kj0m3hnpvhkdvqyjfhbi26rd";
  };

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev"; # gpgme-config; not so sure about gpgme-tool

  propagatedBuildInputs =
    [ libgpgerror glib libassuan pth ]
    ++ lib.optional (qtbase != null) qtbase;

  nativeBuildInputs = [ pkgconfig gnupg ];

  configureFlags = [
    "--enable-fixed-path=${gnupg}/bin"
  ];

  NIX_CFLAGS_COMPILE =
    # qgpgme uses Q_ASSERT which retains build inputs at runtime unless
    # debugging is disabled
    lib.optional (qtbase != null) "-DQT_NO_DEBUG"
    # https://www.gnupg.org/documentation/manuals/gpgme/Largefile-Support-_0028LFS_0029.html
    ++ lib.optional (system == "i686-linux") "-D_FILE_OFFSET_BITS=64";

  meta = with stdenv.lib; {
    homepage = https://gnupg.org/software/gpgme/index.html;
    description = "Library for making GnuPG easier to use";
    longDescription = ''
      GnuPG Made Easy (GPGME) is a library designed to make access to GnuPG
      easier for applications. It provides a High-Level Crypto API for
      encryption, decryption, signing, signature verification and key
      management.
    '';
    license = with licenses; [ lgpl21Plus gpl3Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ fuuzetsu primeos ];
  };
}
