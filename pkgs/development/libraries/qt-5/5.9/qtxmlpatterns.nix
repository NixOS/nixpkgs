{ qtSubmodule, qtbase }:

qtSubmodule {
  name = "qtxmlpatterns";
  qtInputs = [ qtbase ];
}
