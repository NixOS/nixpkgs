{ lib, stdenv, fetchurl, gtk2, libsndfile, pkg-config, python3, wafHook }:

stdenv.mkDerivation rec {
  pname = "lv2";
  version = "1.18.2";

  src = fetchurl {
    url = "https://lv2plug.in/spec/${pname}-${version}.tar.bz2";
    sha256 = "sha256-TokfvHRMBYVb6136gugisUkX3Wbpj4K4Iw29HHqy4F4=";
  };

  nativeBuildInputs = [ pkg-config wafHook ];
  buildInputs = [ gtk2 libsndfile python3 ];

  wafConfigureFlags = lib.optionals stdenv.isDarwin [ "--lv2dir=${placeholder "out"}/lib/lv2" ];

  meta = with lib; {
    homepage = "https://lv2plug.in";
    description = "A plugin standard for audio systems";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
