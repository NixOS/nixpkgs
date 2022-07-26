{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "utf8proc";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "JuliaStrings";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UjZFW+ECU1qbKoo2J2GE8gMEas7trz7YI4mqF5WtOvM=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DUTF8PROC_ENABLE_TESTING=ON"
  ];

  doCheck = true;

  meta = with lib; {
    description = "A clean C library for processing UTF-8 Unicode data";
    homepage = "https://juliastrings.github.io/utf8proc/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.ftrvxmtrx maintainers.sternenseemann ];
  };
}
