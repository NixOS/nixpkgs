{ kde, kdelibs, subversionClient, apr, aprutil,perl }:

kde {

  buildInputs = [ kdelibs subversionClient apr aprutil perl ];

  cmakeFlags = [ "-DBUILD_perldoc=ON" ];

  meta = {
    description = "Subversion and perldoc kioslaves";
  };
}
