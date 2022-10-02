{ lib, stdenv, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "opencl-headers";
  version = "2022.09.23";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "v${version}";
    sha256 = "sha256-kBXkevcapVfpFmI5C77DwULrC8zjcoto+veb49Ksixk=";
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
