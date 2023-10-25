{ qtModule
, qtbase
, qtquick3d
}:

qtModule {
  pname = "qtquickeffectmaker";
  qtInputs = [ qtbase qtquick3d ];
}
