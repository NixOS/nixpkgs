{ lib
, python3Packages
, fetchFromGitHub
, meson
, ninja
, cmake
, pkg-config
, appstream-glib
, blueprint-compiler
, desktop-file-utils
, gtk4
, gst_all_1
, libsoup_3
, libadwaita
, wrapGAppsHook4
}:

python3Packages.buildPythonApplication rec {
  pname = "valuta";
  version = "1.2.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "ideveCore";
    repo = "Valuta";
    rev = "v${version}";
    hash = "sha256-ygroF9hlmsjQTocly7CNL6zQi4N6h8va/ZkJ8w8QHms=";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gst_all_1.gstreamer
    libsoup_3
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    dbus-python
    pygobject3
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "This is a simple application for converting currencies, with support for various APIs";
    homepage = "https://github.com/ideveCore/Valuta";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ arthsmn ];
    mainProgram = "valuta";
    platforms = platforms.linux;
  };
}
