{stdenv, fetchurl, libxml2}:

assert libxml2 != null;

stdenv.mkDerivation {
  name = "libxslt-1.1.22";
  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxslt-1.1.22.tar.gz;
    sha256 = "1nj9pvn4ibhwxpl3ry9n6d7jahppcnqc7mi87nld4vsr2vp3j7sf";
  };
  buildInputs = [libxml2];
  postInstall = "ensureDir $out/nix-support; ln -s ${libxml2}/nix-support/setup-hook $out/nix-support/";
}
