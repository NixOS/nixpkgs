{ lib
, callPackage
, hyDefinedPythonPackages ? python-packages: [] /* Packages like with python.withPackages */
}:
let
  withPackages = (
    python-packages: callPackage ./builder.nix {
      hyDefinedPythonPackages = python-packages;
    }
  );
in
(withPackages hyDefinedPythonPackages) // {
  # Export withPackages function for hy customization
  inherit withPackages;
}
