{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "opencl-headers-2.1-2016-11-29";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "abb29588550c77f8340a6c3683531407013bf26b";
    sha256 = "0zjznq65i4b2h4k36qfbbzq1acf2jdd9vygjv5az1yk7qgsp4jj7";
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
