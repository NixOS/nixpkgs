name: args:

{ kdeApp, cmake, ecm, gettext, kdoctools }:

kdeApp (args // {
  sname = "kde-l10n-${name}";
  name = "kde-l10n-${name}-qt5";

  outputs = [ "out" ];

  nativeBuildInputs =
    [ cmake ecm gettext kdoctools ]
    ++ (args.nativeBuildInputs or []);

  preConfigure = ''
    sed -e 's/add_subdirectory(4)//' -i CMakeLists.txt
    ${args.preConfigure or ""}
  '';

  preFixup = ''
    propagatedBuildInputs=
    propagatedNativeBuildInputs=
  '';
})
