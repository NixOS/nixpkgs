{ stdenv, fetchurl, opensp, pkgconfig, libxml2, curl, fetchpatch }:
        
stdenv.mkDerivation rec {
  name = "libofx-0.9.14";

  src = fetchurl {
    url = "mirror://sourceforge/libofx/${name}.tar.gz";
    sha256 = "02i9zxkp66yxjpjay5dscfh53bz5vxy03zcxncpw09svl6zmf9xq";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2019-9656.patch";
      url = "https://github.com/libofx/libofx/commit/15d0511253d7a8011ab7fa8d1e74c265d17d1b44.patch";
      sha256 = "13lmn8izjdxsi8yvwqn635kc8qcr0cazzhz16lj4fdwwa645z2ca";
    })
  ];

  configureFlags = [ "--with-opensp-includes=${opensp}/include/OpenSP" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ opensp libxml2 curl ];

  meta = { 
    description = "Opensource implementation of the Open Financial eXchange specification";
    homepage = http://libofx.sourceforge.net/;
    license = "LGPL";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}

