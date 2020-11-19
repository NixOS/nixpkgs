{ stdenv, fetchurl, gtk2, libsndfile, pkgconfig, python3, wafHook }:

stdenv.mkDerivation rec {
  pname = "lv2";
  version = "1.18.0";

  src = fetchurl {
    url = "https://lv2plug.in/spec/${pname}-${version}.tar.bz2";
    sha256 = "0gs7401xz23q9vajqr31aa2db8dvssgyh5zrvr4ipa6wig7yb8wh";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ gtk2 libsndfile python3 ];

  wafConfigureFlags = stdenv.lib.optionals stdenv.isDarwin [ "--lv2dir=${placeholder "out"}/lib/lv2" ];

  meta = with stdenv.lib; {
    homepage = "https://lv2plug.in";
    description = "A plugin standard for audio systems";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
