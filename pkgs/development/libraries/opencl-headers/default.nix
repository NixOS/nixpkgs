{ stdenv, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  name = "opencl-headers-${version}";
  version = "2020.03.13";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "v${version}";
    sha256 = "1d9ibiwicaj17757h9yyjc9i2hny8d8npn4spbjscins8972z3hw";
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
