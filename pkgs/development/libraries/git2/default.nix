{ stdenv, fetchFromGitHub, pkgconfig, cmake
, zlib, python, libssh2, openssl, curl, http-parser
, libiconv, Security
}:

stdenv.mkDerivation (rec {
  name = "libgit2-${version}";
  version = "0.26.6";
  # keep the version in sync with pythonPackages.pygit2 and gnome3.libgit2-glib

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${version}";
    sha256 = "17pjvprmdrx4h6bb1hhc98w9qi6ki7yl57f090n9kbhswxqfs7s3";
  };

  cmakeFlags = [ "-DTHREADSAFE=ON" ];

  nativeBuildInputs = [ cmake python pkgconfig ];

  buildInputs = [ zlib libssh2 openssl http-parser curl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  propagatedBuildInputs = stdenv.lib.optional (!stdenv.isLinux) [ libiconv ];

  enableParallelBuilding = true;

  doCheck = false; # hangs. or very expensive?

  meta = with stdenv.lib; {
    description = "The Git linkable library";
    homepage = https://libgit2.github.com/;
    license = licenses.gpl2;
    platforms = with platforms; all;
  };
} // stdenv.lib.optionalAttrs (!stdenv.isLinux) {
})
