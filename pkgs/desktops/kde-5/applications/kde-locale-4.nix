name: args:

{ kdeApp, automoc4, cmake, gettext, kdelibs, perl }:

kdeApp (args // {
  sname = "kde-l10n-${name}";
  name = "kde-l10n-${name}-qt4";

  outputs = [ "out" ];

  nativeBuildInputs =
    [ automoc4 cmake gettext perl ]
    ++ (args.nativeBuildInputs or []);
  buildInputs =
    [ kdelibs ]
    ++ (args.buildInputs or []);

  preConfigure = ''
    sed -e 's/add_subdirectory(5)//' -i CMakeLists.txt
    ${args.preConfigure or ""}
  '';

  preFixup = ''
    propagatedBuildInputs=
    propagatedNativeBuildInputs=
  '';
})
