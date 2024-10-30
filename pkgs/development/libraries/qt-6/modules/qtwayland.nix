{ qtModule
, qtbase
, qtdeclarative
, wayland
, wayland-scanner
, pkg-config
, libdrm
, runCommand
}:

qtModule (finalAttrs: {
  pname = "qtwayland";
  # wayland-scanner needs to be propagated as both build
  # (for the wayland-scanner binary) and host (for the
  # actual wayland.xml protocol definition)
  propagatedBuildInputs = [ qtbase qtdeclarative wayland-scanner ];
  propagatedNativeBuildInputs = [ wayland wayland-scanner ];
  buildInputs = [ wayland libdrm ];
  nativeBuildInputs = [ pkg-config ];

  # Replace vendored wayland.xml with our matching version
  # FIXME: remove when upstream updates past 1.23
  postPatch = ''
    cp ${wayland-scanner}/share/wayland/wayland.xml src/3rdparty/protocol/wayland/wayland.xml
  '';

  passthru = {
    plugins = runCommand "${finalAttrs.finalPackage.name}-only-plugins" { } ''
      mkdir -p "$out/lib/qt-6/plugins"
      ln -s "${finalAttrs.finalPackage}/lib/qt-6/plugins" "$out/lib/qt-6/plugins"
    '';
  };
})
