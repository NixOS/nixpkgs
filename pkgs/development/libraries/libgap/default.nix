{stdenv, fetchurl, gmp}:
stdenv.mkDerivation rec {
  name = "libgap-${version}";
  version = "4.8.6";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "http://mirrors.mit.edu/sage/spkg/upstream/libgap/libgap-${version}.tar.gz";
    sha256 = "1h5fx5a55857w583ql7ly2jl49qyx9mvs7j5abys00ra9gzrpn5v";
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
