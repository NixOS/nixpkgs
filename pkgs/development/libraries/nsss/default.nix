{ stdenv, skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "nsss";
  version = "0.0.1.0";
  sha256 = "0f285bvpvhk40cqjpkc1jb36il0fkzzzjmc89gbbq3awl3w4r1i0";

  description = "An implementation of a subset of the pwd.h, group.h and shadow.h family of functions.";

  # TODO: nsss support
  configureFlags = [
    "--libdir=\${lib}/lib"
    "--dynlibdir=\${lib}/lib"
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
  ];

  postInstall = ''
    # remove all nsss executables from build directory
    rm $(find -name "nsssd-*" -type f -mindepth 1 -maxdepth 1 -executable)
    rm libnsss.* libnsssd.*

    mv doc $doc/share/doc/nsss/html
    mv examples $doc/share/doc/nsss/examples
  '';

}
