{stdenv, fetchurl, gmp}:
stdenv.mkDerivation rec {
  name = "libgap-${version}";
  version = "4.8.3";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "http://mirrors.mit.edu/sage/spkg/upstream/libgap/libgap-${version}.tar.gz";
    sha256 = "0ng4wlw7bj63spf4vkdp43v3ja1fp782lxzdsyf51x26z21idrsq";
  };
  buildInputs = [gmp];
  meta = {
    inherit version;
    description = ''A library-packaged fork of the GAP kernel'';
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
