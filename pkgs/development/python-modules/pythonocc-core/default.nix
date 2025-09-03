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
  libX11,
  libXext,
  libXi,
  libXmu,
  opencascade-occt,
  numpy,
  rapidjson,
  swig,
}:

stdenv.mkDerivation rec {
  pname = "pythonocc-core";
  version = "7.8.1.1";

  src = fetchFromGitHub {
    owner = "tpaviot";
    repo = "pythonocc-core";
    tag = version;
    hash = "sha256-0o2PQEN0/Z7FUPZEo2HxFFa+mN2bZnYI++HVu4ONpNA=";
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
    libX11
    libXext
    libXmu
    libXi
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

  meta = with lib; {
    description = "Python wrapper for the OpenCASCADE 3D modeling kernel";
    homepage = "https://github.com/tpaviot/pythonocc-core";
    changelog = "https://github.com/tpaviot/pythonocc-core/releases/tag/${version}";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
