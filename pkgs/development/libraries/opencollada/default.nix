{ lib, stdenv, fetchFromGitHub, cmake, pkgconfig, libxml2, pcre }:

# The exact revision specified by Blender's install_deps.sh script.
let rev = "18da7f4109a8eafaa290a33f5550501cc4c8bae8"; in

stdenv.mkDerivation {
  name = "opencollada-1.3-${rev}";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCOLLADA";
    inherit rev;
    sha256 = "0ach32ws95mh0ijd8sr22kxka3riq72bb9ng46vs3615dxn7h18d";
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
