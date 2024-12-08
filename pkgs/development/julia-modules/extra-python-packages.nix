{ lib
, python3
}:

# This file contains an extra mapping from Julia packages to the Python packages they depend on.
rec {
  packageMapping = {
    ExcelFiles = ["xlrd"];
    PyPlot = ["matplotlib"];
    PythonPlot = ["matplotlib"];
    SymPy = ["sympy"];
  };

  getExtraPythonPackages = names: lib.concatMap (name: let
    allCandidates = if lib.hasAttr name packageMapping then lib.getAttr name packageMapping else [];
  in
    lib.filter (x: lib.hasAttr x python3.pkgs) allCandidates
  ) names;
}
