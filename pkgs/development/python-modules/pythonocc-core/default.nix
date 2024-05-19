{ lib
, stdenv
, python
, fetchFromGitHub
, cmake
, Cocoa
, fontconfig
, freetype
, libGL
, libGLU
, libX11
, libXext
, libXi
, libXmu
, opencascade-occt
, rapidjson
, swig4
}:

stdenv.mkDerivation rec {
  pname = "pythonocc-core";
  # opencascade-occt was already updated to 7.8.1, and
  # pythonocc-core should sync to that version, but
  # pythonocc-core is not yet available, so we rely on
  # a development snapshot until that is out:
  version = "7.8.1-snapshot";

  src = fetchFromGitHub {
    owner = "tpaviot";
    repo = "pythonocc-core";
    #rev = "refs/tags/${version}";
    rev = "53b7e9dfa409a9673a40a48b57fcdaa6f08d1cb5";
    hash = "sha256-fJt77lh1LeXypa3rGUM3jsi5uyupYfpHu2qbCbCsQD0=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
    --replace "/usr/X11R6/lib/libGL.dylib" "${libGL}/lib/libGL.dylib" \
    --replace "/usr/X11R6/lib/libGLU.dylib" "${libGLU}/lib/libGLU.dylib"
  '';

  nativeBuildInputs = [ cmake swig4 ];
  buildInputs = [
    python opencascade-occt
    freetype libGL libGLU libX11 libXext libXmu libXi
    fontconfig rapidjson
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
