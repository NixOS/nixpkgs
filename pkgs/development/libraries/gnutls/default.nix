{ fetchurl, stdenv, zlib, lzo, libgcrypt
, guileBindings, guile }:

assert guileBindings -> guile != null;

stdenv.mkDerivation rec {

  name = "gnutls-2.4.0";

  src = fetchurl {
    url = "mirror://gnu/gnutls/${name}.tar.bz2";
    sha256 = "11sdwj994lbd8n5icxdj2xr10a0b7s4nh4bm2pf8phncy6kbr0n6";
  };

  patches = [ ./tmpdir.patch ];

  configurePhase = ''
    ./configure --prefix="$out" --enable-guile --with-guile-site-dir="$out/share/guile/site"
  '';

  buildInputs = [zlib lzo libgcrypt]
    ++ stdenv.lib.optional guileBindings guile;

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
  };
}
