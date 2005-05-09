{stdenv, fetchurl, cxxSupport ? true, compat185 ? true}:

stdenv.mkDerivation {
  name = "db4-4.3.28";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://downloads.sleepycat.com/db-4.3.28.NC.tar.gz;
    md5 = "6efcf5f4f30c7170f68d8952739771cd";
  };
  configureFlags = [
    (if cxxSupport then "--enable-cxx" else "--disable-cxx")
    (if cxxSupport then "--enable-compat185" else "--disable-compat185")
  ];
}
