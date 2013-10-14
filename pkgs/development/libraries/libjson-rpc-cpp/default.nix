{ stdenv, fetchurl, cmake, curl }:

let
  name = "libjson-rpc-cpp";
  version = "0.2.1";
in

stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "https://github.com/cinemast/${name}/archive/${version}.tar.gz";
    sha256 = "1pc9nn4968qkda8vr4f9dijn2fcldm8i0ymwmql29h4cl5ghdnpw";
  };

  buildInputs = [ cmake curl ];

  NIX_LDFLAGS = "-lpthread";
  enableParallelBuilding = true;
  doCheck = true;

  checkPhase = "LD_LIBRARY_PATH=out/ ctest";

  meta = {
    description = "C++ framework for json-rpc (json remote procedure call)";
    platforms = stdenv.lib.platforms.linux;
  };
}
