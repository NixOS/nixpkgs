{ stdenv, fetchurl, pkgconfig, libtool, zip, libffi, libsigsegv, readline, gmp,
gnutls, gnome2, cairo, SDL, sqlite, emacsSupport ? false, emacs ? null }:

assert emacsSupport -> (emacs != null);

let # The gnu-smalltalk project has a dependency to the libsigsegv library.
    # The project ships with sources for this library, but deprecated this option.
    # Using the vanilla libsigsegv library results in error: "cannot relocate [...]"
    # Adding --enable-static=libsigsegv to the gnu-smalltalk configuration flags
    # does not help, the error still occurs. The only solution is to build a
    # shared version of libsigsegv.
    libsigsegv-shared = stdenv.lib.overrideDerivation libsigsegv (oldAttrs: {
      configureFlags = [ "--enable-shared" ];
    });

in stdenv.mkDerivation rec {

  version = "3.2.5";
  name = "gnu-smalltalk-${version}";

  src = fetchurl {
    url = "mirror://gnu/smalltalk/smalltalk-${version}.tar.xz";
    sha256 = "1k2ssrapfzhngc7bg1zrnd9n2vyxp9c9m70byvsma6wapbvib6l1";
  };

  # The dependencies and their justification are explained at
  # http://smalltalk.gnu.org/download
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libtool zip libffi libsigsegv-shared readline gmp gnutls gnome2.gtk
    cairo SDL sqlite
  ]
  ++ stdenv.lib.optional emacsSupport emacs;

  configureFlags = stdenv.lib.optional (!emacsSupport) "--without-emacs";

  hardeningDisable = [ "format" ];

  installFlags = stdenv.lib.optional emacsSupport "lispdir=$(out)/share/emacs/site-lisp";

  # For some reason the tests fail if executated with nix-build, but pass if
  # executed within nix-shell --pure.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A free implementation of the Smalltalk-80 language";
    longDescription = ''
      GNU Smalltalk is a free implementation of the Smalltalk-80 language. It
      runs on most POSIX compatible operating systems (including GNU/Linux, of
      course), as well as under Windows. Smalltalk is a dynamic object-oriented
      language, well-versed to scripting tasks.
    '';
    homepage = http://smalltalk.gnu.org/;
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ skeidel ];
  };
}
