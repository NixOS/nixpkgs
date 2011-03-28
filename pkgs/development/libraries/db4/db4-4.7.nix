{stdenv, fetchurl, cxxSupport ? true, compat185 ? true}:

stdenv.mkDerivation {
  name = "db4-4.7.25";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://download-east.oracle.com/berkeley-db/db-4.7.25.tar.gz;
    sha256 = "0gi667v9cw22c03hddd6xd6374l0pczsd56b7pba25c9sdnxjkzi";
  };
  
  configureFlags = [
    (if cxxSupport then "--enable-cxx" else "--disable-cxx")
    (if compat185 then "--enable-compat185" else "--disable-compat185")
  ];
  
}
