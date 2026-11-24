{
  qtModule,
  qtbase,
  qtquick3d,
}:

qtModule {
  pname = "qtquick3dphysics";
  propagatedBuildInputs = [
    qtbase
    qtquick3d
  ];
  meta.mainProgram = "cooker";
}
