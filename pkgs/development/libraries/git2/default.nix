{ stdenv, fetchFromGitHub, pkgconfig, cmake, zlib, python, libssh2, openssl
, curl, http-parser, libiconv }:

stdenv.mkDerivation (rec {
  version = "0.25.1";
  name = "libgit2-${version}";

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${version}";
    sha256 = "1jhikg0gqpdzfzhgv44ybdpm24lvgkc7ki4306lc5lvmj1s2nylj";
  };

  # TODO: `cargo` (rust's package manager) surfaced a serious bug in
  # libgit2 when the `Security.framework` transport is used on Darwin.
  # The upstream issue is tracked at
  # https://github.com/libgit2/libgit2/issues/3885 - feel free to
  # remove this patch as soon as it's resolved (i.E. when cargo is
  # working fine without this patch)
  patches = stdenv.lib.optionals stdenv.isDarwin [
    ./disable-security.framework.patch
  ];

  cmakeFlags = "-DTHREADSAFE=ON";

  nativeBuildInputs = [ cmake python pkgconfig ];
  buildInputs = [ zlib libssh2 openssl http-parser curl ];

  meta = {
    description = "The Git linkable library";
    homepage = https://libgit2.github.com/;
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; all;
  };
} // stdenv.lib.optionalAttrs (!stdenv.isLinux) {
  NIX_LDFLAGS = "-liconv";
  propagatedBuildInputs = [ libiconv ];
})
