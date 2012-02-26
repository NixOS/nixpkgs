{stdenv, fetchurl}:

# To be removed in stdenv-updates, as default.nix is already right there.
stdenv.mkDerivation rec {
  name = "zlib-1.2.6";
  
  src = fetchurl {
    url = "http://www.zlib.net/${name}.tar.gz";
    sha256 = "06x6m33ls1606ni7275q5z392csvh18dgs55kshfnvrfal45w8r1";
  };
}
