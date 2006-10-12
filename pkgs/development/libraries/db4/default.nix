{stdenv, fetchurl, cxxSupport ? true, compat185 ? true}:

stdenv.mkDerivation ({
  name = "db4-4.4.20";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/db-4.4.20.NC.tar.gz;
    md5 = "afd9243ea353bbaa04421488d3b37900";
  };
  configureFlags = [
    (if cxxSupport then "--enable-cxx" else "--disable-cxx")
    (if cxxSupport then "--enable-compat185" else "--disable-compat185")
  ];
} // (if stdenv.system == "i686-cygwin" then {patches = [./cygwin.patch];} else {}))
