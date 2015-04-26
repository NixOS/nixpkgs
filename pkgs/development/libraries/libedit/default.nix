{ stdenv, fetchurl, ncurses, groff }:

stdenv.mkDerivation rec {
  name = "libedit-20150325-3.1";

  src = fetchurl {
    url = "http://www.thrysoee.dk/editline/${name}.tar.gz";
    sha256 = "1if8zi9h52m80ck796an28rrqfljk2n8cn25m3fl0prwz155x2n8";
  };

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  NROFF = "${groff}/bin/nroff";

  postInstall = ''
    sed -i ${stdenv.lib.optionalString (stdenv.isDarwin && stdenv.cc.nativeTools) "''"} s/-lncurses/-lncursesw/g $out/lib/pkgconfig/libedit.pc
  '';

  configureFlags = [ "--enable-widec" ];

  propagatedBuildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage = "http://www.thrysoee.dk/editline/";
    description = "A port of the NetBSD Editline library (libedit)";
    license = licenses.bsd3; 
    platforms = platforms.all;
  };
}
