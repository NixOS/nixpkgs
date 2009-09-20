{ fetchurl, stdenv, zlib, lzo, libgcrypt
, guileBindings, guile }:

assert guileBindings -> guile != null;

stdenv.mkDerivation rec {

  name = "gnutls-2.8.4";

  src = fetchurl {
    url = "mirror://gnu/gnutls/${name}.tar.bz2";
    sha256 = "175qn6m9h5mj77qa0wf3v290cf4ya9z1r01kgg1zz8gpbmxz98a4";
  };

  configurePhase = ''
    ./configure --prefix="$out"                                 \
      --disable-dependency-tracking --enable-fast-install       \
      ${if guileBindings
        then "--enable-guile --with-guile-site-dir=\"$out/share/guile/site\""
        else ""}
  '';

  buildInputs = [zlib lzo]
    ++ stdenv.lib.optional guileBindings guile;

  propagatedBuildInputs = [libgcrypt];

  doCheck = true;
  
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
