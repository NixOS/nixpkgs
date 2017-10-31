{ stdenv, fetchurl, ncurses, groff }:

stdenv.mkDerivation rec {
  name = "libedit-20160903-3.1";

  src = fetchurl {
    url = "http://thrysoee.dk/editline/${name}.tar.gz";
    sha256 = "0rvmm8z6hal5bbp5pljp7yvkpqi4pkas1amizhvg35v0skkx5jqc";
  };

  outputs = [ "out" "dev" ];

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  NROFF = "${groff}/bin/nroff";

  patches = [ ./01-cygwin.patch ];

  propagatedBuildInputs = [ ncurses ];

  configureFlags = [ "--enable-widec" ];

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
