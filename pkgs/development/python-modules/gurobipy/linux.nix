{ python, gurobi }:

python.pkgs.buildPythonPackage {
  pname = "gurobipy";
  version = "9.1.2";
  src = gurobi.src;
  setSourceRoot = "sourceRoot=$(echo gurobi*/*64)";
  patches = [ ./no-clever-setup.patch ];
  postInstall = "mv lib/libgurobi*.so* $out/lib";
  postFixup =
    ''
      patchelf --set-rpath $out/lib \
        $out/lib/${python.libPrefix}/site-packages/gurobipy/gurobipy.so
    '';
}
