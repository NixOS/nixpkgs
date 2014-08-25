{ stdenv, fetchurl, gfortran, perl, liblapack }:

stdenv.mkDerivation rec {
  version = "0.2.2";

  name = "openblas-${version}";
  src = fetchurl {
    url = "https://github.com/xianyi/OpenBLAS/tarball/v${version}";
    sha256 = "13kdx3knff5ajnmgn419g0dnh83plin07p7akwamr3v7z5qfrzqr";
    name = "openblas-${version}.tar.gz";
  };

  preBuild = "cp ${liblapack.src} lapack-${liblapack.meta.version}.tgz";

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
