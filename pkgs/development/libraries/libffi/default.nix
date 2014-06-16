{ fetchurl, stdenv, dejagnu }:

stdenv.mkDerivation rec {
  name = "libffi-3.0.13";

  src = fetchurl {
    url = "ftp://sourceware.org/pub/libffi/${name}.tar.gz";
    sha256 = "077ibkf84bvcd6rw1m6jb107br63i2pp301rkmsbgg6300adxp8x";
  };

  patches = stdenv.lib.optional (stdenv.needsPax) ./libffi-3.0.13-emutramp_pax_proc.patch;

  buildInputs = stdenv.lib.optional doCheck dejagnu;

  configureFlags = [
    "--with-gcc-arch=generic" # no detection of -march= or -mtune=
  ] ++ stdenv.lib.optional (stdenv.needsPax) "--enable-pax_emutramp";

  doCheck = stdenv.isLinux; # until we solve dejagnu problems on darwin and expect on BSD

  dontStrip = stdenv ? cross; # Don't run the native `strip' when cross-compiling.

  postInstall =
    # Install headers in the right place.
    '' ln -s${if stdenv.isFreeBSD then "" else "r"}v "$out/lib/"libffi*/include "$out/include"
    '';

  meta = {
    description = "A foreign function call interface library";

    longDescription = ''
      The libffi library provides a portable, high level programming
      interface to various calling conventions.  This allows a
      programmer to call any function specified by a call interface
      description at run-time.

      FFI stands for Foreign Function Interface.  A foreign function
      interface is the popular name for the interface that allows code
      written in one language to call code written in another
      language.  The libffi library really only provides the lowest,
      machine dependent layer of a fully featured foreign function
      interface.  A layer must exist above libffi that handles type
      conversions for values passed between the two languages.
    '';

    homepage = http://sourceware.org/libffi/;

    # See http://github.com/atgreen/libffi/blob/master/LICENSE .
    license = "free, non-copyleft";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}

