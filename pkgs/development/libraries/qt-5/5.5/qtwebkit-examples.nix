{ qtSubmodule, qttools, qtwebkit }:

qtSubmodule {
  name = "qtwebkit-examples";
  qtInputs = [ qttools qtwebkit ];
}
