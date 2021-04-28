{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libconfig";
  version = "1.7.2";

  src = fetchurl {
    url = "https://hyperrealm.github.io/${pname}/dist/${pname}-${version}.tar.gz";
    sha256 = "1ngs2qx3cx5cbwinc5mvadly0b5n7s86zsc68c404czzfff7lg3w";
  };

  doCheck = true;

  configureFlags = lib.optional stdenv.targetPlatform.isWindows "--disable-examples";

  meta = with lib; {
    homepage = "http://www.hyperrealm.com/libconfig";
    description = "A simple library for processing structured configuration files";
    license = licenses.lgpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = with platforms; linux ++ darwin ++ windows;
  };
}
