{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.4.4";
  name = "theft-${version}";

  src = fetchFromGitHub {
    owner = "silentbicycle";
    repo = "theft";
    rev = "v${version}";
    sha256 = "1csdhnb10k7vsyd44vjpg430nf6a909wj8af2zawdkbvnxn5wxc4";
  };

  preConfigure = "patchShebangs ./scripts/mk_bits_lut";

  doCheck = true;
  checkTarget = "test";
  
  installFlags = [ "PREFIX=$(out)" ];
  postInstall = "install -m644 vendor/greatest.h $out/include/";
  
  meta = {
    description = "A C library for property-based testing";
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://github.com/silentbicycle/theft/";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.kquick ];
  };
}
