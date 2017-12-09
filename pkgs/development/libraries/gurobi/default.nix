with import <nixpkgs> {};
let
  #TODO generify over platform using hostPlatform, etc.
  gurobiPlatform = "linux64";
  version = "7.5.1";
in  
stdenv.mkDerivation {
  pname = "gurobi";
  version = "$version";
  name = "gurobi-${version}";
  description = "A commercial convex and mixed integer optimization solver";
  src = fetchurl {
    url = "http://packages.gurobi.com/7.5/gurobi7.5.1_${gurobiPlatform}.tar.gz";
    sha256 = "7f5c8b0c3d3600ab7a1898f43e238a9d9a32ac1206f2917fb60be9bbb76111b6";
  };
  installPhase = ''
    mkdir -p $out/${gurobiPlatform}
    cp -R ${gurobiPlatform}/* $out/${gurobiPlatform}
    patchelf --set-interpreter \
      ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 $out/${gurobiPlatform}/bin/*
    patchelf --set-rpath ${stdenv.glibc}/lib $out/${gurobiPlatform}/bin/*
    mkdir -p $out/bin
    ln -s $out/${gurobiPlatform}/bin/* $out/bin/
  '';
  GUROBI_HOME = "$out/${gurobiPlatform}";
}
