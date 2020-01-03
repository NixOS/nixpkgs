{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "libedit";
  version = "20191231-3.1";

  src = fetchurl {
    url = "https://thrysoee.dk/editline/${pname}-${version}.tar.gz";
    sha256 = "0wch48nml28jj6ild889745dsg2agm7mpvrmbl1gi98nw6vjrf6v";
  };

  outputs = [ "out" "dev" ];

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  # NROFF = "${groff}/bin/nroff";

  patches = [ ./01-cygwin.patch ];

  propagatedBuildInputs = [ ncurses ];

  postInstall = ''
    find $out/lib -type f | grep '\.\(la\|pc\)''$' | xargs sed -i \
      -e 's,-lncurses[a-z]*,-L${ncurses.out}/lib -lncursesw,g'
  '';

  meta = with stdenv.lib; {
    homepage = http://www.thrysoee.dk/editline/;
    description = "A port of the NetBSD Editline library (libedit)";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
