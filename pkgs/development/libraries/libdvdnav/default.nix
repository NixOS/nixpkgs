{stdenv, fetchurl, libdvdread}:

stdenv.mkDerivation {
  name = "libdvdnav-4.1.3p10";
  
  src = fetchurl {
    url = http://www2.mplayerhq.hu/MPlayer/releases/dvdnav/libdvdnav-4.1.3.tar.bz2;
    sha1 = "d1b95eb8a7caee1fa7580a1abad84d6cb3cad046";
  };

  buildInputs = [libdvdread];

  configureScript = "./configure2"; # wtf?

  preConfigure = ''
    mkdir -p $out
  '';

  # From Handbrake
  patches = [
    ./A00-log-stderr.patch ./A01-program-info.patch ./A02-mult-pgc.patch
    ./A03-quiet.patch ./A04-m4-uid0.patch ./A05-forward-seek.patch
    ./A06-reset-mutex.patch ./A07-missing-menu.patch ./A08-dvdnav-dup.patch
    ./P00-mingw-no-examples.patch
  ];

  meta = {
    homepage = http://www.mplayerhq.hu/;
    description = "A library that implements DVD navigation features such as DVD menus";
  };

  passthru = { inherit libdvdread; };
}
