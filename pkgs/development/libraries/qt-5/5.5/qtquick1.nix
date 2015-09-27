{ qtSubmodule, qtscript, qtsvg, qtwebkit, qtxmlpatterns }:

qtSubmodule {
  name = "qtquick1";
  qtInputs = [ qtscript qtsvg qtwebkit qtxmlpatterns ];
}
