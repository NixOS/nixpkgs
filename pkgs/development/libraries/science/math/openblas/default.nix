{ stdenv, fetchurl, gfortran, perl, liblapack, config }:

# Minimum CPU requirements:
# x86: Pentium 4 (Prescott, circa 2004)
# x86_64: Opteron (circa 2003)
# These are the settings used for the generic builds. Performance will
# be poor on modern systems. The goal of the Hydra builds is simply to
# support as many systems as possible. OpenBLAS may support older
# CPU architectures, but you will need to set 'config.openblas.target'
# and 'config.openblas.preferLocalBuild', which will build it on your
# local machine.

let local = config.openblas.preferLocalBuild or false;
    localTarget = config.openblas.target or "";
in
stdenv.mkDerivation rec {
  version = "0.2.13";

  name = "openblas-${version}";
  src = fetchurl {
    url = "https://github.com/xianyi/OpenBLAS/tarball/v${version}";
    sha256 = "1asg5mix13ipxgj5h2yj2p0r8km1di5jbcjkn5gmhb37nx7qfv6k";
    name = "openblas-${version}.tar.gz";
  };

  preBuild = "cp ${liblapack.src} lapack-${liblapack.meta.version}.tgz";

  buildInputs = [gfortran perl];

  cpu = builtins.head (stdenv.lib.splitString "-" stdenv.system);

  target = if local then localTarget else
    if cpu == "i686" then "PRESCOTT" else
    if cpu == "x86_64" then "OPTERON" else
     # allow autodetect
      "";

  makeFlags = [
    "${if target != "" then "TARGET=" else ""}${target}"
    "FC=gfortran"
    "CC=gcc"
    ''PREFIX="''$(out)"''
    "INTERFACE64=1"
  ];

  meta = with stdenv.lib; {
    description = "Basic Linear Algebra Subprograms";
    license = licenses.bsd3;
    homepage = "https://github.com/xianyi/OpenBLAS";
    platforms = with platforms; linux;
    maintainers = with maintainers; [ ttuegel ];
  };
}
