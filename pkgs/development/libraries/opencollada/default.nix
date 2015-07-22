{ lib, stdenv, fetchFromGitHub, cmake, pkgconfig, libxml2, pcre }:

# The exact revision specified by Blender's install_deps.sh script.
let rev = "3335ac164e68b2512a40914b14c74db260e6ff7d"; in

stdenv.mkDerivation {
  name = "opencollada-1.3-${rev}";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCOLLADA";
    inherit rev;
    sha256 = "0s2m8crbg1kf09hpscrplv65a45dlg157b9c20chrv7wy0qizbw5";
  };

  buildInputs = [ cmake pkgconfig ];

  propagatedBuildInputs = [ libxml2 pcre ];

  enableParallelBuilding = true;

  meta = {
    description = "A library for handling the COLLADA file format";
    homepage = https://github.com/KhronosGroup/OpenCOLLADA/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
