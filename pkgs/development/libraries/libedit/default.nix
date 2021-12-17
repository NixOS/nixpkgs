{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "libedit";
  version = "20210714-3.1";

  src = fetchurl {
    url = "https://thrysoee.dk/editline/${pname}-${version}.tar.gz";
    sha256 = "sha256-MCO0mK1ZP9d0WuOyCrrVRt5Qa2e4+7VXljfKaauC28k=";
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

  meta = with lib; {
    homepage = "http://www.thrysoee.dk/editline/";
    description = "A port of the NetBSD Editline library (libedit)";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
