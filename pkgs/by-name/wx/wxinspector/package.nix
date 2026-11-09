{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtk3,
  wxwidgets_3_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wxinspector";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Noisyfox";
    repo = "wxInspector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AQbV2vAGJXatAXwLAxhWVXTdKqxj2v0THexQyKbroJw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    # FindwxWidgets runs wx-config
    wxwidgets_3_3
  ];

  buildInputs = [
    gtk3
    wxwidgets_3_3
  ];

  # Upstream only builds a static library; consumers may link it into shared objects
  cmakeFlags = [ (lib.cmakeBool "CMAKE_POSITION_INDEPENDENT_CODE" true) ];

  meta = {
    description = "Runtime widget and layout inspector for wxWidgets applications";
    homepage = "https://github.com/Noisyfox/wxInspector";
    license = lib.licenses.wxWindowsException31;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
