{ qtModule
, qtbase
, perl
}:

qtModule {
  pname = "qtsvg";
  nativeBuildInputs = [ perl ];
  qtInputs = [ qtbase ];
  outputs = [ "out" "dev" "bin" ];
}
