{
  lib,
  python,
  callPackage,
  buildPythonPackage,
  cmake,
  pybind11,
  mkPythonMetaPackage,
  vtk,
}:
let
  ocp-source = callPackage ./ocp-source.nix { };
in
buildPythonPackage (finalAttrs: {
  pname = "cadquery-ocp";
  inherit (ocp-source) version;
  pyproject = false;

  src = ocp-source;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [ pybind11 ] ++ ocp-source.buildInputs;

  dependencies = [
    (mkPythonMetaPackage {
      inherit (finalAttrs) pname version meta;
      dependencies = [ vtk ];
    })
  ];

  cmakeFlags = [
    (lib.cmakeFeature "PYTHON_SP_DIR" "${placeholder "out"}/${python.sitePackages}")
  ];

  pythonImportsCheck = [
    "OCP"
    "OCP.gp"
  ];

  passthru = {
    inherit ocp-source;
  };

  meta = {
    description = "Python wrapper for OCCT generated using pywrap";
    homepage = "https://github.com/CadQuery/OCP";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      # tnytown
      qbisi
    ];
  };
})
