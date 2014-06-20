{ stdenv, fetchurl }:

assert stdenv.isDarwin;

let
  version  = "4.2.1";   # Upstream GCC version, from `gcc/BASE-VER'.
  revision = "5666.3";  # Apple's fork revision number.
in

stdenv.mkDerivation {
  name = "gcc-apple-bootstrap-${version}.${revision}";

  src = fetchurl {
    url = "http://r.research.att.com/tools/gcc-42-5666.3-darwin11.pkg";
    sha256 = "0p86vb83cnargqfk2ksfzwdlx88bxb7nwr4rialvyy7m26s96f1g";
  };

  buildCommand = ''
    /usr/bin/xar -xf $src
    /bin/pax --insecure -rz -f usr.pkg/Payload -s ",./usr,$out,"
    for prog in c++ cpp gcc g++ gfortran gcov; do
      ln -s $out/bin/$prog{-4.2,}
    done
  '';

  langC = true;
  langCC = true;
}
