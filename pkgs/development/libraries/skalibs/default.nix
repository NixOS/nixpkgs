{ stdenv, fetchurl }:

let

  version = "2.0.0.0";

in stdenv.mkDerivation rec {

  name = "skalibs-${version}";

  src = fetchurl {
    url = "http://skarnet.org/software/skalibs/${name}.tar.gz";
    sha256 = "0cz30wqg8fnkwjlacs4s3sjs3l34sa91xgci95fmb187zhiq693n";
  };

  dontDisableStatic = true;

  configureFlags = [
    "--enable-force-devr"       # assume /dev/random works
    "--libdir=\${prefix}/lib"
    "--includedir=\${prefix}/include"
    "--sysdepdir=\${prefix}/lib/skalibs/sysdeps"
  ] ++ (if stdenv.isDarwin then [ "--disable-shared" ] else [ "--enable-shared" ]);

  meta = {
    homepage = http://skarnet.org/software/skalibs/;
    description = "A set of general-purpose C programming libraries";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
