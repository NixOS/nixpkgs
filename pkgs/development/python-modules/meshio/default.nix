{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  h5py,
  netcdf4,
  numpy,
  rich,

  # tests
  exdown,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "meshio";
  version = "5.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "meshio";
    tag = "v${version}";
    hash = "sha256-2j+5BYftCiy+g33UbsgCMWBRggGBJBx5VoEdSqQ/mV0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    h5py
    netcdf4
    numpy
    rich
  ];

  pythonImportsCheck = [ "meshio" ];

  nativeCheckInputs = [
    exdown
    pytestCheckHook
  ];

  disabledTests = [
    # RuntimeError: Not a valid Netgen mesh
    "test_advanced"

    # ValueError: cannot reshape array of size 12 into shape (1936876918,3)
    "test_area"

    # Error: Couldn't read file /build/source/tests/meshes/vtk/06_color_scalars.vtk as vtk
    # Illegal VTK header
    "test_color_scalars"
    "test_pathlike"

    # AssertionError
    "test_comma_space"

    # ValueError: could not convert string to float: 'np.float64(63.69616873214543)'
    "test_dolfin"

    # ValueError: cannot reshape array of size 1 into shape
    "test_gmsh22"
    "test_gmsh40"
    "test_gmsh41"

    # meshio._exceptions.ReadError: Header of ugrid file is ill-formed
    "test_io"
    "test_volume"

    # ValueError: invalid literal for int() with base 10: 'version'
    "test_point_cell_refs"

    # Error: Couldn't read file /build/source/tests/meshes/vtu/01_raw_binary_int64.vtu as vtu
    "test_read_from_file"

    # ValueError: cannot reshape array of size 12 into shape (1936876918,3)
    # -- or
    # Error: Couldn't read file /build/source/tests/meshes/medit/hch_strct.4.meshb as medit
    # Invalid code
    # -- or
    # AssertionError
    # -- or
    # Error: Couldn't read file /build/source/tests/meshes/msh/insulated-2.2.msh as either of ansys, gmsh
    "test_reference_file"

    # UnboundLocalError: cannot access local variable 'points' where it is not associated with a value
    # -- or
    # Error: Couldn't read file /build/source/tests/meshes/vtk/00_image.vtk as vtk
    # Illegal VTK header
    "test_structured"

    # Error: Couldn't read file /build/source/tests/meshes/ply/bun_zipper_res4.ply as ply
    # Expected ply
    "test_read_pathlike"
    "test_read_str"
    "test_write_pathlike"
    "test_write_str"
  ];

  meta = {
    description = "I/O for mesh files";
    homepage = "https://github.com/nschloe/meshio";
    changelog = "https://github.com/nschloe/meshio/blob/v${version}/CHANGELOG.md";
    mainProgram = "meshio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wd15 ];
  };
}
