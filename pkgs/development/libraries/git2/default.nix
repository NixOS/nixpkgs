{stdenv, fetchurl, cmake, zlib, python, libssh2, openssl, http-parser}:

stdenv.mkDerivation rec {
  version = "0.21.1";
  name = "libgit2-${version}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/libgit2/libgit2/tarball/v${version}";
    sha256 = "0afbvcsryg7bsmbfj23l09b1xngkmqhf043njl8wm44qslrxibkz";
  };

  cmakeFlags = "-DTHREADSAFE=ON";

  nativeBuildInputs = [ cmake python ];
  buildInputs = [ zlib libssh2 openssl http-parser ];

  meta = {
    description = "the Git linkable library";
    homepage = http://libgit2.github.com/;
    license = with stdenv.lib.licenses; gpl2;
    platforms = with stdenv.lib.platforms; all;
  };
}
