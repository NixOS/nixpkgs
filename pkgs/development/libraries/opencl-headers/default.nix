{ stdenv, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  name = "opencl-headers-${version}";
  version = "2020.06.16";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "v${version}";
    sha256 = "0viiwhfqccw90r3mr45ab3wyhabpdrihplj5842brn5ny0ayh73z";
  };

  installPhase = ''
    mkdir -p $out/include/CL
    cp CL/* $out/include/CL
  '';

  meta = with stdenv.lib; {
    description = "Khronos OpenCL headers version ${version}";
    homepage = "https://www.khronos.org/registry/cl/";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
