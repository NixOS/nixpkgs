{stdenv, fetchurl, perl, zip}:

stdenv.mkDerivation {
  name = "nss-3.10";
  builder = ./builder.sh;

  nsssrc = fetchurl {
    url = ftp://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_10_RTM/src/nss-3.10.tar.gz;
    md5 = "f0d75d52aff21f88d9c055bdb78f54f8";
  };

  nsprsrc =  fetchurl {
    url = ftp://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.6/src/nspr-4.6.tar.gz;
    md5 = "a37c3cde875502e05576429312452465";
  };

  buildInputs = [perl zip];
}
