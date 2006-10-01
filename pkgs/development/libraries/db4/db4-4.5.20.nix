{stdenv, fetchurl, cxxSupport ? true, compat185 ? true}:

stdenv.mkDerivation ({
  name = "db4-4.5.20";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://download.oracle.com/berkeley-db/db-4.5.20.NC.tar.gz;
    md5 = "1bfa6256f8d546b97bef1f448ab09875";
  };
  configureFlags = [
    (if cxxSupport then "--enable-cxx" else "--disable-cxx")
    (if cxxSupport then "--enable-compat185" else "--disable-compat185")
  ];
} // (if stdenv.system == "i686-cygwin" then {patches = [./cygwin.patch];} else {}))
