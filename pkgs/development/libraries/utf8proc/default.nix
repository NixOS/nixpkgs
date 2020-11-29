{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "utf8proc";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "JuliaStrings";
    repo = pname;
    rev = "v${version}";
    sha256 = "0czk8xw1jra0fjf6w4bcaridyz3wz2br3v7ik1g7z0j5grx9n8r1";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  # the pkg-config file is not created in the cmake installation
  # process, so we use the Makefile and install it manually
  # see https://github.com/JuliaStrings/utf8proc/issues/198
  preConfigure = "make libutf8proc.pc prefix=$out";
  postInstall = "install -Dm644 ../libutf8proc.pc -t $out/lib/pkgconfig/";

  meta = with stdenv.lib; {
    description = "A clean C library for processing UTF-8 Unicode data";
    homepage = "https://juliastrings.github.io/utf8proc/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.ftrvxmtrx ];
  };
}
