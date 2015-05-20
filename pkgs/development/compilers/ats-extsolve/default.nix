{ stdenv, fetchurl, ats2, python, z3, pkgconfig, json_c }:

stdenv.mkDerivation {
  name = "ats-extsolve-0pre11177d9";

  buildInputs = [ python z3 ats2 pkgconfig json_c ];

  src = fetchurl {
    url = "https://github.com/wdblair/ATS-Postiats-contrib/archive/11177d9194b852392d5e92e67d0ecc7b6abc02bf.tar.gz";
    sha256 = "12fhlcpq5b4pc3h21w1i7yv1ymrll2g4zlf1pvg0v8cr6aa6i813";
  };

  postUnpack = ''
    export PATSHOMERELOC="$PWD/$sourceRoot"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$PATSHOMERELOC"
    export INCLUDE_ATS="-IATS $PATSHOMERELOC"
  '';

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
