{stdenv, fetchurl, mpfr}:
stdenv.mkDerivation rec {
  name = "mpfi-${version}";
  version = "1.5.3";
  file_nr = "37331";
  src = fetchurl {
    # NOTE: the file_nr is whats important here. The actual package name (including the version)
    # is ignored. To find out the correct file_nr, go to https://gforge.inria.fr/projects/mpfi/
    # and click on Download in the section "Latest File Releases".
    url = "https://gforge.inria.fr/frs/download.php/file/${file_nr}/mpfi-${version}.tar.bz2";
    sha256 = "0bqr8yibl7jbrp0bw7xk1lm7nis7rv26jsz6y8ycvih8n9bx90r3";
  };
  buildInputs = [mpfr];
  meta = {
    inherit version;
    description = ''A multiple precision interval arithmetic library based on MPFR'';
    homepage = https://gforge.inria.fr/projects/mpfi/;
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
