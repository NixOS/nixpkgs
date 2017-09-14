{ qtSubmodule, qttools }:

qtSubmodule {
  name = "qttranslations";
  qtInputs = [ qttools ];
}
