{ stdenv, skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "utmps";
  version = "0.0.2.0";
  sha256 = "0fzq3qm88sm5ibl9k9k6ns6jd7iw72vh9k10bsfl5dxd2yi6iqyr";

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

