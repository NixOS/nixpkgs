{stdenv, fetchurl, cxxSupport ? true, compat185 ? true}:

stdenv.mkDerivation {
  name = "db4-4.5.20";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://download-east.oracle.com/berkeley-db/db-4.5.20.tar.gz;
    md5 = "b0f1c777708cb8e9d37fb47e7ed3312d";
  };
  
  configureFlags = [
    (if cxxSupport then "--enable-cxx" else "--disable-cxx")
    (if compat185 then "--enable-compat185" else "--disable-compat185")
  ];
  
  patches = [./cygwin-4.5.patch ./register-race-fix.patch];
}
