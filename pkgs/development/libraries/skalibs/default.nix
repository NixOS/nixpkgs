{ skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "skalibs";
  version = "2.8.0.0";
  sha256 = "06hyiq68jh32qwr2mydw3dbnm4zzpynnnmprd5g4iqavsycyvh53";

  description = "A set of general-purpose C programming libraries";

  outputs = [ "lib" "dev" "doc" "out" ];

  configureFlags = [
    # assume /dev/random works
    "--enable-force-devr"
    "--libdir=\${lib}/lib"
    "--dynlibdir=\${lib}/lib"
    "--includedir=\${dev}/include"
    "--sysdepdir=\${lib}/lib/skalibs/sysdeps"
  ];

  postInstall = ''
    rm -rf sysdeps.cfg
    rm libskarnet.*

    mv doc $doc/share/doc/skalibs/html
  '';

}
