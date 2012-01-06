{ kde, kdelibs, perl }:

kde {
  buildInputs = [ kdelibs perl ];

  cmakeFlags = [ "-DBUILD_perldoc=ON" ];

  meta = {
    description = "perldoc: kioslave";
  };
}
