{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "libffi-3.0.5";
  src = fetchurl {
    url = "ftp://sourceware.org/pub/libffi/${name}.tar.gz";
    sha256 = "1i0ms6ilhjzz0691nymnvs5a3b5lf95n6p99l65z2zn83rd7pahf";
  };

  doCheck = true;

  postInstall =
    # Install headers in the right place.
    '' ln -sv "$out/lib/"libffi*/include "$out/include"
    '';

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

    license = "http://sources.redhat.com/cgi-bin/cvsweb.cgi/~checkout~/libffi/LICENSE?rev=1.6&content-type=text/plain&cvsroot=libffi&only_with_tag=MAIN";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
