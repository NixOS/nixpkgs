{ lib
, python3
}:

# This file contains an extra mapping from Julia packages to the Python packages they depend on.

let
  inherit (lib)
    concatMap
    filter
    getAttr
    hasAttr
    ;

  packageMapping = {
    ExcelFiles = ["xlrd"];
    PyPlot = ["matplotlib"];
    PythonPlot = ["matplotlib"];
    SymPy = ["sympy"];
  };

  getExtraPythonPackages = names: concatMap (name: let
    allCandidates = if hasAttr name packageMapping then getAttr name packageMapping else [];
  in
    filter (x: hasAttr x python3.pkgs) allCandidates
  ) names;
in
{
  inherit packageMapping getExtraPythonPackages;
}
