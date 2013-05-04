{ kde, kdelibs, perl }:

kde {
#todo: doesn't build
  buildInputs = [ kdelibs perl ];

  cmakeFlags = [ "-DBUILD_perldoc=ON" ];

  meta = {
    description = "perldoc: kioslave";
  };
}
