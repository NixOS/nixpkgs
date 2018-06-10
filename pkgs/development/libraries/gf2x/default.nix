{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  name = "gf2x-${version}";
  version = "1.1";

  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "http://gforge.inria.fr/frs/download.php/file/30873/gf2x-1.1.tar.gz";
    sha256 = "17w4b39j9dvri5s278pxi8ha7mf47j87kq1lr802l4408rh02gqd";
  };

  meta = {
    description = ''Routines for fast arithmetic in GF(2)[x]'';
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = ["x86_64-linux"];
  };
}
