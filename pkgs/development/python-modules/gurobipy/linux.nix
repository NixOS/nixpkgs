{ lib, fetchurl, python }:

python.pkgs.buildPythonPackage rec {
  pname = "gurobipy";
  version = "9.1.2";
  src = fetchurl {
    url = "https://packages.gurobi.com/${lib.versions.majorMinor version}/gurobi${version}_linux64.tar.gz";
    sha256 = "7f60bd675f79476bb2b32cd632aa1d470f8246f2b033b7652d8de86f6e7e429b";
  };
  setSourceRoot = "sourceRoot=$(echo gurobi*/*64)";
  patches = [ ./no-clever-setup.patch ];
  postInstall = "mv lib/libgurobi*.so* $out/lib";
  postFixup =
    ''
      patchelf --set-rpath $out/lib \
        $out/lib/${python.libPrefix}/site-packages/gurobipy/gurobipy.so
    '';
}
