{ skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "skalibs";
  version = "2.9.3.0";
  sha256 = "0i1vg3bh0w3bpj7cv0kzs6q9v2dd8wa2by8h8j39fh1qkl20f6ph";

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
