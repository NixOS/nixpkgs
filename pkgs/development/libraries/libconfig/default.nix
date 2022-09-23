{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libconfig";
  version = "1.7.3";

  src = fetchurl {
    url = "https://hyperrealm.github.io/${pname}/dist/${pname}-${version}.tar.gz";
    sha256 = "sha256-VFFm1srAN3RDgdHpzFpUBQlOe/rRakEWmbz/QLuzHuc=";
  };

  doCheck = true;

  configureFlags = lib.optional (stdenv.targetPlatform.isWindows || stdenv.hostPlatform.isStatic) "--disable-examples";

  meta = with lib; {
    homepage = "http://www.hyperrealm.com/libconfig";
    description = "A simple library for processing structured configuration files";
    license = licenses.lgpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = with platforms; linux ++ darwin ++ windows;
  };
}
