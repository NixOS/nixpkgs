{lib, stdenv, fetchurl, mpfr}:
stdenv.mkDerivation rec {
  pname = "mpfi";
  version = "1.5.4";
  file_nr = "37331";
  src = fetchurl {
    # NOTE: the file_nr is whats important here. The actual package name (including the version)
    # is ignored. To find out the correct file_nr, go to https://gforge.inria.fr/projects/mpfi/
    # and click on Download in the section "Latest File Releases".
    url = "https://gforge.inria.fr/frs/download.php/file/${file_nr}/mpfi-${version}.tar.bz2";
    sha256 = "sha256-I4PUV7IIxs088uZracTOR0d7Kg2zH77AzUseuqJHGS8=";
  };
  buildInputs = [mpfr];
  meta = {
    inherit version;
    description = "A multiple precision interval arithmetic library based on MPFR";
    homepage = "https://gforge.inria.fr/projects/mpfi/";
    license = lib.licenses.lgpl21Plus;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.unix;
  };
}
