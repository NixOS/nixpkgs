{ stdenv, fetchurl, ncurses, groff }:

stdenv.mkDerivation rec {
  name = "libedit-20130712-3.1";

  src = fetchurl {
    url = "http://www.thrysoee.dk/editline/${name}.tar.gz";
    sha256 = "0dwav34041sariyl00nr106xmn123bnxir4qpn5y47vgssfim6sx";
  };

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  NROFF = "${groff}/bin/nroff";

  postInstall = ''
    sed -i s/-lncurses/-lncursesw/g $out/lib/pkgconfig/libedit.pc
  '';

  configureFlags = "--enable-widec";

  propagatedBuildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage = "http://www.thrysoee.dk/editline/";
    description = "A port of the NetBSD Editline library (libedit)";
    license = licenses.bsd3; 
  };
}
