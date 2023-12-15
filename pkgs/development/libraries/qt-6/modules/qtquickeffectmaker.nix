{ qtModule
, qtbase
, qtquick3d
}:

qtModule {
  pname = "qtquickeffectmaker";
  propagatedBuildInputs = [ qtbase qtquick3d ];
}
