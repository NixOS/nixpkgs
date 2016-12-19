{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "opencl-headers-2.1.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "c1770dcc6cf1daadec1905e7393f3691c1dde200";
    sha256 = "0m9fkblqja0686i2jjqiszvq3df95gp01a2674xknlmkd6525rck";
  };

  installPhase = ''
    mkdir -p $out/include/CL
    cp * $out/include/CL
  '';

  meta = with stdenv.lib; {
    description = "Khronos OpenCL headers";
    homepage = https://www.khronos.org/registry/cl/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
