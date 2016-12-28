{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "0.4.34";
  name = "libzen-${version}";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/libzen/${version}/libzen_${version}.tar.bz2";
    sha256 = "02krmhl6dplidz6h251ajpzzdhzzm0hp0lwwv9rgn55xjgh4yxw3";
  };

  nativeBuildInputs = [ autoreconfHook ];
  configureFlags = [ "--enable-shared" ];

  sourceRoot = "./ZenLib/Project/GNU/Library/";

  preConfigure = "sh autogen.sh";

  meta = with stdenv.lib; {
    description = "Shared library for libmediainfo and mediainfo";
    homepage = https://mediaarea.net/;
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
  };
}
