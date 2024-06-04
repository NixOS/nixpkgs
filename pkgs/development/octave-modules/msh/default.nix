{ buildOctavePackage
, lib
, fetchFromGitHub
# Octave Dependencies
, splines
# Other Dependencies
, gmsh
, gawk
, pkg-config
, dolfin
, autoconf, automake
}:

buildOctavePackage rec {
  pname = "msh";
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "carlodefalco";
    repo = "msh";
    rev = "v${version}";
    sha256 = "sha256-UnMrIruzm3ARoTgUlMMxfjTOMZw/znZUQJmj3VEOw8I=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf automake
    dolfin
  ];

  buildInputs = [
    dolfin
  ];

  propagatedBuildInputs = [
    gmsh
    gawk
    dolfin
  ];

  requiredOctavePackages = [
    splines
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/msh/index.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Create and manage triangular and tetrahedral meshes for Finite Element or Finite Volume PDE solvers";
    longDescription = ''
      Create and manage triangular and tetrahedral meshes for Finite Element or
      Finite Volume PDE solvers. Use a mesh data structure compatible with
      PDEtool. Rely on gmsh for unstructured mesh generation.
    '';
    # Not technically broken, but missing some functionality.
    # dolfin needs to be its own stand-alone library for the last tests to pass.
  };
}
