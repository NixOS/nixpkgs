{ stdenv, fetchurl, ats2, python, z3, pkgconfig, json_c }:

stdenv.mkDerivation {
  name = "ats-extsolve-0pre6a9b752";

  buildInputs = [ python z3 ats2 pkgconfig json_c ];

  src = fetchurl {
    url = "https://github.com/githwxi/ATS-Postiats-contrib/archive/6a9b752efb8af1e4f77213f9e81fc2b7fa050877.tar.gz";
    sha256 = "1zz4fqjm1rdvpm0m0sdck6vx55iiqlk2p8z078fca2q9xyxqjkqd";
  };

  postUnpack = ''
    export PATSHOMERELOC="$PWD/$sourceRoot";
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$PATSHOMERELOC"
  '';

  patches = [ ./misc-fixes.patch ];

  preBuild = "cd projects/MEDIUM/ATS-extsolve";

  buildFlags = [ "setup" "patsolve" ];

  installPhase = ''
    install -d -m755 $out/bin
    install -m755 patsolve $out/bin
  '';

  meta = {
    platforms = ats2.meta.platforms;
    homepage = http://www.illtyped.com/projects/patsolve;
    description = "External Constraint-Solving for ATS2";
    maintainer = [ stdenv.lib.maintainers.shlevy ];
  };
}
