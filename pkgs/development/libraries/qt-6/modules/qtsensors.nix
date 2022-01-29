{ qtModule
, qtbase
, qtdeclarative
, qtsvg
}:

# TODO sensorfw https://github.com/sailfishos/sensorfw

qtModule {
  pname = "qtsensors";
  qtInputs = [ qtbase qtdeclarative qtsvg ];
  outputs = [ "out" "dev" "bin" ];
}
