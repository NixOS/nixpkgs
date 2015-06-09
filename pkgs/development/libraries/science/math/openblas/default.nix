{ stdenv, fetchurl, gfortran, perl, liblapack, config, coreutils }:

with stdenv.lib;

let local = config.openblas.preferLocalBuild or false;
    binary =
      {
        i686-linux = "32";
        x86_64-linux = "64";
        x86_64-darwin = "64";
      }."${stdenv.system}" or (throw "unsupported system: ${stdenv.system}");
    genericFlags =
      [
        "DYNAMIC_ARCH=1"
        "NUM_THREADS=64"
        "BINARY=${binary}"
      ];
    localFlags = config.openblas.flags or
      optionals (hasAttr "target" config.openblas) [ "TARGET=${config.openblas.target}" ];
in
stdenv.mkDerivation rec {
  version = "0.2.14";

  name = "openblas-${version}";
  src = fetchurl {
    url = "https://github.com/xianyi/OpenBLAS/tarball/v${version}";
    sha256 = "0av3pd96j8rx5i65f652xv9wqfkaqn0w4ma1gvbyz73i6j2hi9db";
    name = "openblas-${version}.tar.gz";
  };

  preBuild = "cp ${liblapack.src} lapack-${liblapack.meta.version}.tgz";

  nativeBuildInputs = optionals stdenv.isDarwin [coreutils] ++ [gfortran perl];

  makeFlags =
    (if local then localFlags else genericFlags)
    ++
    optionals stdenv.isDarwin ["MACOSX_DEPLOYMENT_TARGET=10.9"]
    ++
    [
      "FC=gfortran"
      # Note that clang is available through the stdenv on OSX and
      # thus is not an explicit dependency.
      "CC=${if stdenv.isDarwin then "clang" else "gcc"}"
      ''PREFIX="''$(out)"''
      "INTERFACE64=1"
    ];

  meta = with stdenv.lib; {
    description = "Basic Linear Algebra Subprograms";
    license = licenses.bsd3;
    homepage = "https://github.com/xianyi/OpenBLAS";
    platforms = with platforms; unix;
    maintainers = with maintainers; [ ttuegel ];
  };
}
