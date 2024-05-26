{ config, lib, stdenv, fetchurl, pkg-config, libtool
, zip, libffi, libsigsegv, readline, gmp
, gnutls, gtk2, cairo, SDL, sqlite
, emacsSupport ? config.emacsSupport or false, emacs ? null }:

assert emacsSupport -> (emacs != null);

let # The gnu-smalltalk project has a dependency to the libsigsegv library.
    # The project ships with sources for this library, but deprecated this option.
    # Using the vanilla libsigsegv library results in error: "cannot relocate [...]"
    # Adding --enable-static=libsigsegv to the gnu-smalltalk configuration flags
    # does not help, the error still occurs. The only solution is to build a
    # shared version of libsigsegv.
    libsigsegv-shared = lib.overrideDerivation libsigsegv (oldAttrs: {
      configureFlags = [ "--enable-shared" ];
    });

in stdenv.mkDerivation rec {

  version = "3.2.5";
  pname = "gnu-smalltalk";

  src = fetchurl {
    url = "mirror://gnu/smalltalk/smalltalk-${version}.tar.xz";
    sha256 = "1k2ssrapfzhngc7bg1zrnd9n2vyxp9c9m70byvsma6wapbvib6l1";
  };

  patches = [ ./fix_mkorder.patch ];

  # The dependencies and their justification are explained at
  # http://smalltalk.gnu.org/download
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libtool zip libffi libsigsegv-shared readline gmp gnutls gtk2
    cairo SDL sqlite
  ]
  ++ lib.optional emacsSupport emacs;

  configureFlags = lib.optional (!emacsSupport) "--without-emacs";

  hardeningDisable = [ "format" ];

  installFlags = lib.optional emacsSupport "lispdir=$(out)/share/emacs/site-lisp";

  # For some reason the tests fail if executated with nix-build, but pass if
  # executed within nix-shell --pure.
  doCheck = false;

  meta = with lib; {
    description = "A free implementation of the Smalltalk-80 language";
    longDescription = ''
      GNU Smalltalk is a free implementation of the Smalltalk-80 language. It
      runs on most POSIX compatible operating systems (including GNU/Linux, of
      course), as well as under Windows. Smalltalk is a dynamic object-oriented
      language, well-versed to scripting tasks.
    '';
    homepage = "http://smalltalk.gnu.org/";
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
