{ lib, stdenv, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "opencl-headers";
  version = "2023.04.17";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "v${version}";
    sha256 = "sha256-FK6pbIqNVVW9p6ozUVzuRxfxvibCA4cNFfhT22WjSzE=";
  };

  installPhase = ''
    mkdir -p $out/include/CL
    cp CL/* $out/include/CL
  '';

  meta = with lib; {
    description = "Khronos OpenCL headers version ${version}";
    homepage = "https://www.khronos.org/registry/cl/";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
