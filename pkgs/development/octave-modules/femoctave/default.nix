{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  nix-update-script,
  # deps
  triangle,
  withTriangle ? false,
}:

buildOctavePackage rec {
  pname = "femoctave";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "AndreasStahel";
    repo = "FEMoctave";
    tag = "v.${version}";
    sha256 = "sha256-7N1tY5z1TnQyRbbzh40HgNLThGi/VdILfEqjDe05xL4=";
  };

  propagatedBuildInputs =
    [ ]
    ++ lib.optionals withTriangle [
      triangle
    ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=v.(.*)" ]; };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/femoctave/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    description = "Use FEM for solving boundary value problems in two space dimensions.";
    longDescription = ''
      Use FEM for solving boundary value problems in two space dimensions.

      Note:
      If using the Triangle features of femoctave use
        octavePackages.femotave.override { withTriangle = true; }
    '';
  };
}
