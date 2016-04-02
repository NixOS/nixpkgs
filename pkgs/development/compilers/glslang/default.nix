{ stdenv, fetchFromGitHub, cmake, bison }:

stdenv.mkDerivation rec {
  name = "glslang-${version}";
  version = "2016-07-27";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "8c8505c60454549181d78301933f3f108e2f55e6";
    sha256 = "1219sq86pz6k8nzg9sqm34b0rdv6kkjirg54y6b2r5ak568r4kwx";
  };

  patches = [ ./install-headers.patch ];

  buildInputs = [ cmake bison ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Khronos reference front-end for GLSL and ESSL";
  };
}
