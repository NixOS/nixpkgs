{stdenv, fetchurl, libdvdread}:

stdenv.mkDerivation {
  name = "libdvdnav-4.1.3";
  
  src = fetchurl {
    url = http://www2.mplayerhq.hu/MPlayer/releases/dvdnav/libdvdnav-4.1.3.tar.bz2;
    sha1 = "d1b95eb8a7caee1fa7580a1abad84d6cb3cad046";
  };

  buildInputs = [libdvdread];

  configureScript = "./configure2"; # wtf?

  preConfigure = ''
    mkdir -p $out
  '';

  meta = {
    homepage = http://www.mplayerhq.hu/;
    description = "A library that implements DVD navigation features such as DVD menus";
  };

  passthru = { inherit libdvdread; };
}
