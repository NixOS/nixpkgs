{ skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "nsss";
  version = "0.0.1.1";
  sha256 = "14y1vl7n8vd5fh9bwiwwxxslisli8pz3a2f1sfv12l0p8ngpgm57";

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
