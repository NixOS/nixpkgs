{ stdenv, fetchurl, gfortran, perl, liblapack, config }:

let local = config.openblas.preferLocalBuild or false;
    localTarget = config.openblas.target or "";
in
stdenv.mkDerivation rec {
  version = "0.2.11";

  name = "openblas-${version}";
  src = fetchurl {
    url = "https://github.com/xianyi/OpenBLAS/tarball/v${version}";
    sha256 = "1va4yhzgj2chcj6kaxgfbzirajp1zgvkic61959aka2xq2c5igms";
    name = "openblas-${version}.tar.gz";
  };

  preBuild = "cp ${liblapack.src} lapack-${liblapack.meta.version}.tgz";

  buildInputs = [gfortran perl];

  cpu = builtins.head (stdenv.lib.splitString "-" stdenv.system);

  target = if local then localTarget else
    if cpu == "i686" then "P2" else
    if cpu == "x86_64" then "CORE2" else
     # allow autodetect
      "";

  makeFlags = "${if target != "" then "TARGET=" else ""}${target} FC=gfortran CC=cc PREFIX=\"\$(out)\" INTERFACE64=1";

  meta = with stdenv.lib; {
    description = "Basic Linear Algebra Subprograms";
    license = licenses.bsd3;
    homepage = "https://github.com/xianyi/OpenBLAS";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ttuegel ];
  };
}
