{ stdenv, fetchFromGitHub
, version # "12" for "1.2", "22" for "2.2" and so on
}:

stdenv.mkDerivation {
  name = "opencl-headers-${version}-2017-07-18";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "f039db6764d52388658ef15c30b2237bbda49803";
    sha256 = "0z04i330zr8czak2624q71aajdcq7ly8mb5bgala5m235qjpsrh7";
  };

  installPhase = ''
    mkdir -p $out/include/CL
    cp opencl${version}/CL/* $out/include/CL
  '';

  meta = with stdenv.lib; {
    description = "Khronos OpenCL headers version ${version}";
    homepage = https://www.khronos.org/registry/cl/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
