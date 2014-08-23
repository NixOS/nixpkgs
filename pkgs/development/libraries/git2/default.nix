{stdenv, fetchurl, cmake, zlib, python}:

stdenv.mkDerivation rec {
  version = "0.20.0";
  name = "libgit2-${version}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/libgit2/libgit2/tarball/v${version}";
    sha256 = "1iyncz8fqazw683dxjls3lf5pw3f5ma8kachkvjz7dsq57wxllbj";
  };

  cmakeFlags = "-DTHREADSAFE=ON";

  nativeBuildInputs = [ cmake python ];
  buildInputs = [ zlib ];

  meta = {
    description = "the Git linkable library";
    homepage = http://libgit2.github.com/;
    license = with stdenv.lib.licenses; gpl2;
    platforms = with stdenv.lib.platforms; all;
  };
}
