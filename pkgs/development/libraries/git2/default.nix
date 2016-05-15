{ stdenv, fetchurl, pkgconfig, cmake, zlib, python, libssh2, openssl, http-parser, libiconv }:

stdenv.mkDerivation (rec {
  version = "0.24.1";
  name = "libgit2-${version}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/libgit2/libgit2/tarball/v${version}";
    sha256 = "0rw80480dx2f6a2wbb1bwixygg1iwq3r7vwhxdmkkf4lpxd35jhd";
  };

  cmakeFlags = "-DTHREADSAFE=ON";

  nativeBuildInputs = [ cmake python pkgconfig ];
  buildInputs = [ zlib libssh2 openssl http-parser ];

  meta = {
    description = "the Git linkable library";
    homepage = http://libgit2.github.com/;
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; all;
  };
} // stdenv.lib.optionalAttrs (!stdenv.isLinux) {
  NIX_LDFLAGS = "-liconv";
  propagatedBuildInputs = [ libiconv ];
})
