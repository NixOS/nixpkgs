{ skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "utmps";
  version = "0.0.2.1";
  sha256 = "1q90mcn50irhhrzl3h9bvhsn7hac0zgg67b6hfhmc5yvh4c8wnr4";

  description = "A secure utmpx and wtmp implementation";

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
    # remove all execline executables from build directory
    rm $(find -type f -mindepth 1 -maxdepth 1 -executable)
    rm libutmps.*

    mv doc $doc/share/doc/utmps/html
    mv examples $doc/share/doc/utmps/examples
  '';
}

