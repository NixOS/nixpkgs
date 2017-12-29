{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.4.3";
  name = "theft-${version}";

  src = fetchFromGitHub {
    owner = "silentbicycle";
    repo = "theft";
    rev = "v${version}";
    sha256 = "1ibh8np12lafnrsrvjbbzlyq45zq654939x0y22vdnc6s8dpbhw4";
  };

  preConfigure = "patchShebangs ./scripts/mk_bits_lut";

  doCheck = true;
  checkTarget = "test";
  
  installFlags = [ "PREFIX=$(out)" ];
  postInstall = "install -m644 vendor/greatest.h $out/include/";
  
  meta = {
    description = "A C library for property-based testing";
    platforms = stdenv.lib.platforms.linux;
    homepage = "http://github.com/silentbicycle/theft/";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.kquick ];
  };
}
