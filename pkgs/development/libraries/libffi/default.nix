{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "libffi-3.2.1";

  src = fetchurl {
    url = "ftp://sourceware.org/pub/libffi/${name}.tar.gz";
    sha256 = "0dya49bnhianl0r65m65xndz6ls2jn1xngyn72gd28ls3n7bnvnh";
  };

  patches = if stdenv.isCygwin then [ ./3.2.1-cygwin.patch ] else null;

  outputs = [ "dev" "out" "doc" ];

  configureFlags = [
    "--with-gcc-arch=generic" # no detection of -march= or -mtune=
    "--enable-pax_emutramp"
  ];

  dontStrip = stdenv ? cross; # Don't run the native `strip' when cross-compiling.

  # Install headers and libs in the right places.
  postInstall = ''
    mkdir -p "$dev/"
    mv "$out/lib/${name}/include" "$dev/include"
    rmdir "$out/lib/${name}"
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
    license = stdenv.lib.licenses.free;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
