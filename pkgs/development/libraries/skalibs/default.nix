{ skawarePackages, pkgs }:

with skawarePackages;

buildPackage {
  pname = "skalibs";
  version = "2.11.1.0";
  sha256 = "1fga2kmzcp2llqv5nzrmgm33p1jz7y9pnaghzbxf8ldnsns800a0";

  description = "A set of general-purpose C programming libraries";

  outputs = [ "lib" "dev" "doc" "out" ];

  configureFlags = [
    # assume /dev/random works
    "--enable-force-devr"
    "--libdir=\${lib}/lib"
    "--dynlibdir=\${lib}/lib"
    "--includedir=\${dev}/include"
    "--sysdepdir=\${lib}/lib/skalibs/sysdeps"
    # Empty the default path, which would be "/usr/bin:bin".
    # It would be set when PATH is empty. This hurts hermeticity.
    "--with-default-path="
  ];

  postInstall = ''
    rm -rf sysdeps.cfg
    rm libskarnet.*

    mv doc $doc/share/doc/skalibs/html
  '';

  passthru.tests = {
    # fdtools is one of the few non-skalib packages that depends on skalibs
    # and might break if skalibs gets an breaking update.
    fdtools = pkgs.fdtools;
  };

}
