{stdenv, fetchurl, cmake, zlib, python, libssh2, openssl, http-parser}:

stdenv.mkDerivation rec {
  version = "0.21.2";
  name = "libgit2-${version}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/libgit2/libgit2/tarball/v${version}";
    sha256 = "0icf119lhha96rk8m6s38sczjr0idr7yczw6knby61m81a25a96y";
  };

  cmakeFlags = "-DTHREADSAFE=ON";

  nativeBuildInputs = [ cmake python ];
  buildInputs = [ zlib libssh2 openssl http-parser ];

  meta = {
    description = "The Git linkable library";
    homepage = http://libgit2.github.com/;
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; all;
  };
}
