{stdenv, fetchurl, gmp, mpir, mpfr, openblas, ntl}:
stdenv.mkDerivation rec {
  name = "flint-${version}";
  version = "2.5.2";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "http://www.flintlib.org/flint-${version}.tar.gz";
    sha256 = "11syazv1a8rrnac3wj3hnyhhflpqcmq02q8pqk2m6g2k6h0gxwfb";
  };
  buildInputs = [gmp mpir mpfr openblas ntl];
  configureFlags = "--with-gmp=${gmp} --with-mpir=${mpir} --with-mpfr=${mpfr} --with-blas=${openblas} --with-ntl=${ntl}";
  meta = {
    inherit version;
    description = ''Fast Library for Number Theory'';
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://www.flintlib.org/;
    downloadPage = "http://www.flintlib.org/downloads.html";
    updateWalker = true;
  };
}
