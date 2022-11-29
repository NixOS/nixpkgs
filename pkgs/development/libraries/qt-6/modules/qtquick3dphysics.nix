{ qtModule
, qtbase
, qtquick3d
}:

qtModule {
  pname = "qtquick3dphysics";
  qtInputs = [ qtbase qtquick3d ];
}
