{stdenv, fetchurl, cxxSupport ? true, compat185 ? true}:

stdenv.mkDerivation {
  name = "db4-4.4.20";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://downloads.sleepycat.com/db-4.4.20.NC.tar.gz;
    md5 = "bc1f4433cf08c956e5146037ba050581";
  };
  configureFlags = [
    (if cxxSupport then "--enable-cxx" else "--disable-cxx")
    (if cxxSupport then "--enable-compat185" else "--disable-compat185")
  ];
}
