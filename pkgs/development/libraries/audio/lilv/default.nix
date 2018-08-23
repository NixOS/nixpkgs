{ stdenv, fetchurl, lv2, pkgconfig, python, serd, sord, sratom, libsndfile }:

stdenv.mkDerivation rec {
  name = "lilv-${version}";
  version = "0.24.4";

  src = fetchurl {
    url = "https://download.drobilla.net/${name}.tar.bz2";
    sha256 = "0f24cd7wkk5l969857g2ydz2kjjrkvvddg1g87xzzs78lsvq8fy3";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lv2 python serd sord sratom libsndfile ];

  configurePhase = "${python.interpreter} waf configure --prefix=$out --default-lv2-path=~/.lv2:~/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";

  buildPhase = "${python.interpreter} waf";

  installPhase = "${python.interpreter} waf install";

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/lilv;
    description = "A C library to make the use of LV2 plugins";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
