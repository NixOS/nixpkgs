{ stdenv, skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "skalibs";
  version = "2.7.0.0";
  sha256 = "068pkbl91mi35amlhv491dwrbzyfifrlxijss0g2vf693xvx6lxm";

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
