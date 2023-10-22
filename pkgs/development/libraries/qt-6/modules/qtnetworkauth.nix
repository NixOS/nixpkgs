{ qtModule, qtbase }:

qtModule {
  pname = "qtnetworkauth";
  propagatedBuildInputs = [ qtbase ];
}
