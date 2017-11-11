{ lib, stdenv, fetchFromGitHub, cmake, pkgconfig, libxml2, pcre }:

stdenv.mkDerivation rec {
  name = "opencollada-${version}";

  version = "1.6.59";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCOLLADA";
    rev = "v${version}";
    sha256 = "0gpjvzcfyilb96x5ywajxgkw42ipwp4my36z9cq686bd9vpp3q0g";
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
