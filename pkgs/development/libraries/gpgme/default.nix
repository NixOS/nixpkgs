{ stdenv, fetchurl, libgpgerror, gnupg, pkgconfig, glib, pth, libassuan }:

stdenv.mkDerivation rec {
  name = "gpgme-1.9.0";

  src = fetchurl {
    url = "mirror://gnupg/gpgme/${name}.tar.bz2";
    sha256 = "1ssc0gs02r4fasabk7c6v6r865k2j02mpb5g1vkpbmzsigdzwa8v";
  };

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev"; # gpgme-config; not so sure about gpgme-tool

  propagatedBuildInputs = [ libgpgerror glib libassuan pth ];

  nativeBuildInputs = [ pkgconfig gnupg ];

  configureFlags = [
    "--enable-fixed-path=${gnupg}/bin"
  ];

  # https://www.gnupg.org/documentation/manuals/gpgme/Largefile-Support-_0028LFS_0029.html
  NIX_CFLAGS_COMPILE =
    with stdenv; lib.optional (system == "i686-linux") "-D_FILE_OFFSET_BITS=64";

  meta = with stdenv.lib; {
    homepage = "https://gnupg.org/software/gpgme/index.html";
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
