{ fetchurl, stdenv }:

stdenv.mkDerivation (rec {
  name = "libffi-3.0.10";

  src = fetchurl {
    url = "ftp://sourceware.org/pub/libffi/${name}.tar.gz";
    sha256 = "0bs97dgvqrbzc9zv9y2ff5flfvbmfyc68dpnxvm6mdcygq1bj7ph";
  };

  doCheck = true;

  meta = {
    description = "libffi, a foreign function call interface library";

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

    homepage = http://sources.redhat.com/libffi/;

    # See http://github.com/atgreen/libffi/blob/master/LICENSE .
    license = "free, non-copyleft";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}

//

# Don't run the native `strip' when cross-compiling.
(if (stdenv ? cross)
 then { dontStrip = true; }
 else { }))
