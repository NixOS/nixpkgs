{ python3 }:
let
  python = python3.override rec {
    packageOverrides = self: super: {
      xonsh = self.callPackage ./unwrapped.nix { };
      xontribs = (import ./xontribs { python3 = python; });
    };
  };

  withXontribs = xontributor: let
    selectedXontribs = (xontributor python.pkgs.xontribs);
  in python.pkgs.toPythonApplication (python.pkgs.xonsh.overridePythonAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ selectedXontribs;

    passthru = rec {
      inherit withXontribs;
      inherit (python.pkgs) xontribs;
    };
  }));
in withXontribs (x: [ x.xontrib-vox ])
