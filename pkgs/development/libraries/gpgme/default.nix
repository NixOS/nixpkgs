{ stdenv, fetchurl, libgpgerror, gnupg, pkgconfig, glib, pth, libassuan
, file, which, ncurses
, texinfo
, buildPackages
, qtbase ? null
, pythonSupport ? false, swig2 ? null, python ? null
}:

let
  inherit (stdenv) lib;
  inherit (stdenv.hostPlatform) system;
in

stdenv.mkDerivation rec {
  name = "gpgme-${version}";
  version = "1.13.0";

  src = fetchurl {
    url = "mirror://gnupg/gpgme/${name}.tar.bz2";
    sha256 = "0c6676g0yhfsmy32i1dgwh5cx0ja8vhcqf4k08zad177m53kxcnl";
  };

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev"; # gpgme-config; not so sure about gpgme-tool

  propagatedBuildInputs =
    [ libgpgerror glib libassuan pth ]
    ++ lib.optional (qtbase != null) qtbase;

  nativeBuildInputs = [ file pkgconfig gnupg texinfo ]
  ++ lib.optionals pythonSupport [ python swig2 which ncurses ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  postPatch =''
    substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file
  '';

  configureFlags = [
    "--enable-fixed-path=${gnupg}/bin"
    "--with-libgpg-error-prefix=${libgpgerror.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
  ] ++ lib.optional pythonSupport "--enable-languages=python";

  NIX_CFLAGS_COMPILE =
    # qgpgme uses Q_ASSERT which retains build inputs at runtime unless
    # debugging is disabled
    lib.optional (qtbase != null) "-DQT_NO_DEBUG"
    # https://www.gnupg.org/documentation/manuals/gpgme/Largefile-Support-_0028LFS_0029.html
    ++ lib.optional (system == "i686-linux") "-D_FILE_OFFSET_BITS=64";

  checkInputs = [ which ];

  doCheck = true;

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
