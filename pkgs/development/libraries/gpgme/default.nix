{ stdenv, fetchurl, fetchpatch
, autoreconfHook, libgpgerror, gnupg, pkgconfig, glib, pth, libassuan
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
  pname = "gpgme";
  version = "1.15.0";

  src = fetchurl {
    url = "mirror://gnupg/gpgme/${pname}-${version}.tar.bz2";
    sha256 = "0nqfipv5s4npfidsm1rs3kpq0r0av9bfqfd5r035jibx5k0jniqb";
  };

  patches = [
    (fetchpatch { # gpg: Send --with-keygrip when listing keys
      name = "c4cf527ea227edb468a84bf9b8ce996807bd6992.patch";
      url = "http://git.gnupg.org/cgi-bin/gitweb.cgi?p=gpgme.git;a=patch;h=c4cf527ea227edb468a84bf9b8ce996807bd6992";
      sha256 = "0y0b0lb2nq5p9kx13b59b2jaz157mvflliw1qdvg1v1hynvgb8m4";
    })
    # https://lists.gnupg.org/pipermail/gnupg-devel/2020-April/034591.html
    (fetchpatch {
      name = "0001-Fix-python-tests-on-non-Linux.patch";
      url = "https://lists.gnupg.org/pipermail/gnupg-devel/attachments/20200415/f7be62d1/attachment.obj";
      sha256 = "00d4sxq63601lzdp2ha1i8fvybh7dzih4531jh8bx07fab3sw65g";
    })
    # Disable python tests on Darwin as they use gpg (see configureFlags below)
  ] ++ lib.optional stdenv.isDarwin ./disable-python-tests.patch
  # Fix _AC_UNDECLARED_WARNING for autoconf≥2.70. See https://lists.gnupg.org/pipermail/gnupg-devel/2020-November/034643.html
  ++ lib.optional stdenv.cc.isClang ./fix-clang-autoconf-undeclared-warning.patch;

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev"; # gpgme-config; not so sure about gpgme-tool

  propagatedBuildInputs =
    [ libgpgerror glib libassuan pth ]
    ++ lib.optional (qtbase != null) qtbase;

  nativeBuildInputs = [ pkgconfig gnupg texinfo autoreconfHook ]
  ++ lib.optionals pythonSupport [ python swig2 which ncurses ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  configureFlags = [
    "--enable-fixed-path=${gnupg}/bin"
    "--with-libgpg-error-prefix=${libgpgerror.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
  ] ++ lib.optional pythonSupport "--enable-languages=python"
  # Tests will try to communicate with gpg-agent instance via a UNIX socket
  # which has a path length limit. Nix on darwin is using a build directory
  # that already has quite a long path and the resulting socket path doesn't
  # fit in the limit. https://github.com/NixOS/nix/pull/1085
    ++ lib.optionals stdenv.isDarwin [ "--disable-gpg-test" ];

  NIX_CFLAGS_COMPILE = toString (
    # qgpgme uses Q_ASSERT which retains build inputs at runtime unless
    # debugging is disabled
    lib.optional (qtbase != null) "-DQT_NO_DEBUG"
    # https://www.gnupg.org/documentation/manuals/gpgme/Largefile-Support-_0028LFS_0029.html
    ++ lib.optional (system == "i686-linux") "-D_FILE_OFFSET_BITS=64");

  checkInputs = [ which ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://gnupg.org/software/gpgme/index.html";
    changelog = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gpgme.git;a=blob;f=NEWS;hb=refs/tags/gpgme-${version}";
    description = "Library for making GnuPG easier to use";
    longDescription = ''
      GnuPG Made Easy (GPGME) is a library designed to make access to GnuPG
      easier for applications. It provides a High-Level Crypto API for
      encryption, decryption, signing, signature verification and key
      management.
    '';
    license = with licenses; [ lgpl21Plus gpl3Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
