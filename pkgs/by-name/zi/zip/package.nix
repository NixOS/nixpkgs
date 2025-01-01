{
  lib,
  stdenv,
  fetchurl,
  enableNLS ? false,
  libnatspec ? null,
  libiconv,
}:

assert enableNLS -> libnatspec != null;

stdenv.mkDerivation rec {
  pname = "zip";
  version = "3.0";

  src = fetchurl {
    urls = [
      "ftp://ftp.info-zip.org/pub/infozip/src/zip${lib.replaceStrings [ "." ] [ "" ] version}.tgz"
      "https://src.fedoraproject.org/repo/pkgs/zip/zip30.tar.gz/7b74551e63f8ee6aab6fbc86676c0d37/zip30.tar.gz"
    ];
    sha256 = "0sb3h3067pzf3a7mlxn1hikpcjrsvycjcnj9hl9b1c3ykcgvps7h";
  };
  prePatch = ''
    substituteInPlace unix/Makefile --replace 'CC = cc' ""
  '';

  hardeningDisable = [ "format" ];

  makefile = "unix/Makefile";
  buildFlags = if stdenv.hostPlatform.isCygwin then [ "cygwin" ] else [ "generic" ];
  installFlags = [
    "prefix=${placeholder "out"}"
    "INSTALL=cp"
  ];

  patches = [
    # Trying to use `memset` without declaring it is flagged as an error with clang 16, causing
    # the `configure` script to incorrectly define `ZMEM`. That causes the build to fail due to
    # incompatible redeclarations of `memset`, `memcpy`, and `memcmp` in `zip.h`.
    ./fix-memset-detection.patch
    # Implicit declaration of `closedir` and `opendir` cause dirent detection to fail with clang 16.
    ./fix-implicit-declarations.patch
    # Buffer overflow on Unicode characters in path names
    # https://bugzilla.redhat.com/show_bug.cgi?id=2165653
    ./buffer-overflow-on-utf8-rh-bug-2165653.patch
    # Fixes forward declaration errors with timezone.c
    ./fix-time.h-not-included.patch
  ] ++ lib.optionals (enableNLS && !stdenv.hostPlatform.isCygwin) [ ./natspec-gentoo.patch.bz2 ];

  buildInputs =
    lib.optional enableNLS libnatspec
    ++ lib.optional stdenv.hostPlatform.isCygwin libiconv;

  meta = with lib; {
    description = "Compressor/archiver for creating and modifying zipfiles";
    homepage = "http://www.info-zip.org";
    license = licenses.bsdOriginal;
    platforms = platforms.all;
    maintainers = with maintainers; [ RossComputerGuy ];
    mainProgram = "zip";
  };
}
