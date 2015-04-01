{stdenv, fetchurl, fetchpatch, zlib, expat}:

stdenv.mkDerivation rec {
  name = "exiv2-0.24";

  src = fetchurl {
    url = "http://www.exiv2.org/${name}.tar.gz";
    sha256 = "13pgvz14kyapxl89pxjaq3274k56d5lzfckpg1g9z7gvqzk4797l";
  };

  patches = [(fetchpatch {
    name = "CVE-2014-9449.diff";
    url = "http://dev.exiv2.org/projects/exiv2/repository/revisions/3264/diff?format=diff&rev_to=3263";
    sha256 = "02w0fksl966d4v6bkg6rq3wmvv8xjpvfp47qr0nv1xq0bphxqzag";
  })];

  propagatedBuildInputs = [zlib expat];

# configure script finds zlib&expat but it thinks that they're in /usr
  configureFlags = "--with-zlib=${zlib} --with-expat=${expat}";

  meta = {
    homepage = http://www.exiv2.org/;
    description = "A library and command-line utility to manage image metadata";
    maintainers = [stdenv.lib.maintainers.urkud];
    platforms = stdenv.lib.platforms.all;
  };
}
