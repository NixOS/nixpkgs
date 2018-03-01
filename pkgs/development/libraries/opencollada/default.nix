{ lib, stdenv, fetchFromGitHub, cmake, pkgconfig, libxml2, pcre }:

stdenv.mkDerivation rec {
  name = "opencollada-${version}";

  version = "1.6.62";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCOLLADA";
    rev = "v${version}";
    sha256 = "0bqki6sdvxsp9drzj87ma6n7m98az9pr0vyxhgw8b8b9knk8c48r";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake ];

  propagatedBuildInputs = [ libxml2 pcre ];

  enableParallelBuilding = true;

  meta = {
    description = "A library for handling the COLLADA file format";
    homepage = https://github.com/KhronosGroup/OpenCOLLADA/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
