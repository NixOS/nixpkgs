{ fetchurl, stdenv, zlib, lzo, libtasn1, nettle
, guileBindings, guile, perl, psmisc }:

assert guileBindings -> guile != null;

stdenv.mkDerivation rec {

  name = "gnutls-3.0.18";

  src = fetchurl {
    url = "mirror://gnu/gnutls/${name}.tar.xz";
    sha256 = "1ynqnj1j6rrzplk2i64dik34829r0y7lwk4qlvjx993q3mj7z863";
  };

  configurePhase = ''
    ./configure --prefix="$out"                                 \
      --disable-dependency-tracking --enable-fast-install       \
      --without-p11-kit                                         \
      --with-lzo --with-libtasn1-prefix="${libtasn1}"		\
      ${if guileBindings
        then "--enable-guile --with-guile-site-dir=\"$out/share/guile/site\""
        else ""}
  '';

  buildInputs = [ zlib lzo ]
    ++ stdenv.lib.optional guileBindings guile;

  buildNativeInputs = [ perl ];

  propagatedBuildInputs = [ nettle libtasn1 ];

  # XXX: Disable tests on non-Linux because of the `mini-loss-time' hack
  # below, which is Linux-specific.
  doCheck = stdenv.isLinux;

  postCheck =
    # Kill a process that's left behind.
    stdenv.lib.optionalString doCheck "${psmisc}/bin/killall mini-loss-time";

  meta = {
    description = "The GNU Transport Layer Security Library";

    longDescription = ''
       GnuTLS is a project that aims to develop a library which
       provides a secure layer, over a reliable transport
       layer. Currently the GnuTLS library implements the proposed
       standards by the IETF's TLS working group.

       Quoting from the TLS protocol specification:

       "The TLS protocol provides communications privacy over the
       Internet. The protocol allows client/server applications to
       communicate in a way that is designed to prevent eavesdropping,
       tampering, or message forgery."
    '';

    homepage = http://www.gnu.org/software/gnutls/;
    license = "LGPLv2.1+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
