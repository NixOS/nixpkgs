{ qtModule, qtbase, qtdeclarative
, perl
}:

qtModule {
  pname = "qtwebchannel";
  nativeBuildInputs = [ perl ];
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}

