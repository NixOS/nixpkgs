{ stdenv, fetchurl, gfortran, perl, liblapack, config }:

with stdenv.lib;

let local = config.openblas.preferLocalBuild or false;
    genericFlags =
      [
        "DYNAMIC_ARCH=1"
        "TARGET=GENERIC"
        "NUM_THREADS=64"
      ];
    localFlags = config.openblas.flags or
      optionals (hasAttr "target" config.openblas) [ "TARGET=${config.openblas.target}" ];
in
stdenv.mkDerivation rec {
  version = "0.2.12";

  name = "openblas-${version}";
  src = fetchurl {
    url = "https://github.com/xianyi/OpenBLAS/tarball/v${version}";
    sha256 = "0389dnybfvag8zms5w1xlwcknq2l2am1vcfssjkax49r1rq2f5qg";
    name = "openblas-${version}.tar.gz";
  };

  preBuild = "cp ${liblapack.src} lapack-${liblapack.meta.version}.tgz";

  nativeBuildInputs = [gfortran perl];

  makeFlags =
    (if local then localFlags else genericFlags)
    ++
    [
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
