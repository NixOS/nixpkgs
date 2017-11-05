{ stdenv, fetchFromGitHub, pkgconfig, cmake, zlib, python, libssh2, openssl, curl, http-parser, libiconv }:

stdenv.mkDerivation (rec {
  name = "libgit2-${version}";
  version = "0.26.0";
  # keep the version in sync with pythonPackages.pygit2 and gnome3.libgit2-glib

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${version}";
    sha256 = "0zrrmfkfhd2xb4879z5khjb6xsdklrm01f1lscrs2ks68v25fk78";
  };

  cmakeFlags = "-DTHREADSAFE=ON";

  nativeBuildInputs = [ cmake python pkgconfig ];

  buildInputs = [ zlib libssh2 openssl http-parser curl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The Git linkable library";
    homepage = https://libgit2.github.com/;
    license = licenses.gpl2;
    platforms = with platforms; all;
  };
} // stdenv.lib.optionalAttrs (!stdenv.isLinux) {
  NIX_LDFLAGS = "-liconv";
  propagatedBuildInputs = [ libiconv ];
})
