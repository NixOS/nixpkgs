{ stdenv, fetchurl, boost }:

let
  version = stdenv.lib.removePrefix "boost-" boost.name;
  pkgid = stdenv.lib.replaceChars ["-" "."] ["_" "_"] boost.name;
in

stdenv.mkDerivation {
  name = "boost-headers-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/boost/${pkgid}.tar.bz2";
    sha256 = "07df925k56pbz3gvhxpx54aij34qd40a7sxw4im11brnwdyr4zh4";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/include
    tar xf $src -C $out/include --strip-components=1 ${pkgid}/boost
  '';

  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.viric stdenv.lib.maintainers.simons ];
  };
}
