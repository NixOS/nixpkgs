{ stdenv, fetchurl, ncurses, groff }:

stdenv.mkDerivation rec {
  name = "libedit-20140620-3.1";

  src = fetchurl {
    url = "http://www.thrysoee.dk/editline/${name}.tar.gz";
    sha256 = "1wnapwcpl4yq8p95j898jl0hsr39if28qzm5a7zwkbplihm9nax2";
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
  };
}
