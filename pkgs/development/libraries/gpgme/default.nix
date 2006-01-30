{stdenv, fetchurl, libgpgerror, gnupg}:

stdenv.mkDerivation {
  name = "gpgme-1.0.3";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gpgme-1.0.3.tar.gz;
    md5 = "4d33cbdf844fcee1c724e4cf2a32dd11";
  };
  buildInputs = [libgpgerror gnupg];
}
