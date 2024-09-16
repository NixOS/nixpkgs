{
  lib,
  stdenv,
  python,
  fetchFromGitHub,
  cmake,
  Cocoa,
  fontconfig,
  freetype,
  libGL,
  libGLU,
  libX11,
  libXext,
  libXi,
  libXmu,
  opencascade-occt,
  rapidjson,
  swig,
}:

stdenv.mkDerivation rec {
  pname = "pythonocc-core";
  version = "7.6.2";

  src = fetchFromGitHub {
    owner = "tpaviot";
    repo = "pythonocc-core";
    rev = "refs/tags/${version}";
    hash = "sha256-45pqPQ07KYlpFwJSAYVHbzuqDQTbAvPpxReal52DCzU=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
    --replace "/usr/X11R6/lib/libGL.dylib" "${libGL}/lib/libGL.dylib" \
    --replace "/usr/X11R6/lib/libGLU.dylib" "${libGLU}/lib/libGLU.dylib"
  '';

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
    rapidjson
  ] ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  cmakeFlags = [
    "-Wno-dev"
    "-DPYTHONOCC_INSTALL_DIRECTORY=${placeholder "out"}/${python.sitePackages}/OCC"
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
    maintainers = with maintainers; [ gebner ];
  };
}
