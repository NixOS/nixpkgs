{ skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "skalibs";
  version = "2.10.0.1";
  sha256 = "1chwjzlh13jbrldk77h3i4qjqv8hjpvvd3papcb8j46mvj7sxysg";

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

}
