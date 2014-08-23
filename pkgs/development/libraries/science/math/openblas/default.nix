{ stdenv, fetchurl, gfortran, perl }:

stdenv.mkDerivation rec {
  version = "0.2.2";
  lapack_version = "3.4.1";
  lapack_src = fetchurl {
    url = "http://www.netlib.org/lapack/lapack-${lapack_version}.tgz";
    sha256 = "93b910f94f6091a2e71b59809c4db4a14655db527cfc5821ade2e8c8ab75380f";
  };

  name = "openblas-${version}";
  src = fetchurl {
    url = "https://github.com/xianyi/OpenBLAS/tarball/v${version}";
    sha256 = "13kdx3knff5ajnmgn419g0dnh83plin07p7akwamr3v7z5qfrzqr";
    name = "openblas-${version}.tar.gz";
  };

  preBuild = "cp ${lapack_src} lapack-${lapack_version}.tgz";

  buildInputs = [gfortran perl];

  cpu = builtins.head (stdenv.lib.splitString "-" stdenv.system);

  target = if cpu == "i686" then "P2" else 
    if cpu == "x86_64" then "CORE2" else
     # allow autodetect
      "";

  makeFlags = "${if target != "" then "TARGET=" else ""}${target} FC=gfortran CC=cc PREFIX=\"\$(out)\"";

  meta = {
    description = "Basic Linear Algebra Subprograms";
    license = stdenv.lib.licenses.bsd3;
    homepage = "https://github.com/xianyi/OpenBLAS";
    platforms = [ "x86_64-linux" ];
  };
}
