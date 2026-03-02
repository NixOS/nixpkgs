{
  lib,
  stdenv,
  python,
  fetchFromGitHub,
  cmake,
  fontconfig,
  freetype,
  libGL,
  libGLU,
  libx11,
  libxext,
  libxi,
  libxmu,
  opencascade-occt,
  numpy,
  rapidjson,
  swig,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pythonocc-core";
  # To avoid overriding opencascade-occt from 7.9.3 to 7.9.0. Go back to regular release next version.
  version = "7.9.0-unstable-2025-12-31";

  src = fetchFromGitHub {
    owner = "tpaviot";
    repo = "pythonocc-core";
    rev = "2f8f1a7d99312e8b3e81d0bb2adab9b1e717d37b";
    hash = "sha256-fni6crPs58e8MUr2SfVHVD5nPFIEQcOfuAMLXJlWg88=";
  };

  nativeBuildInputs = [
    cmake
    swig
  ];
  buildInputs = [
    python
    opencascade-occt
    freetype
    libGL
    libGLU
    libx11
    libxext
    libxmu
    libxi
    fontconfig
    numpy
    rapidjson
  ];

  cmakeFlags = [
    "-Wno-dev"
    "-DPYTHONOCC_INSTALL_DIRECTORY=${placeholder "out"}/${python.sitePackages}/OCC"
    "-DPYTHONOCC_MESHDS_NUMPY=on"
  ];

  passthru = {
    # `python3Packages.pythonocc-core` must be updated in tandem with
    # `opencascade-occt`, and including it in the bulk updates often breaks it.
    skipBulkUpdate = true;
  };

  meta = {
    description = "Python wrapper for the OpenCASCADE 3D modeling kernel";
    homepage = "https://github.com/tpaviot/pythonocc-core";
    changelog = "https://github.com/tpaviot/pythonocc-core/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
