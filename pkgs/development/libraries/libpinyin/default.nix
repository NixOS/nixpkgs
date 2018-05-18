{ stdenv, fetchurl, fetchFromGitHub, autoreconfHook, glib, db, pkgconfig }:

let
  modelData = fetchurl {
    url    = "mirror://sourceforge/libpinyin/models/model14.text.tar.gz";
    sha256 = "0qqk30nflj07zjhs231c95ln4yj4ipzwxxiwrxazrg4hb8bhypqq";
  };
in
stdenv.mkDerivation rec {
  name = "libpinyin-${version}";
  version = "2.1.91";

  nativeBuildInputs = [ autoreconfHook glib db pkgconfig ];

  postUnpack = ''
    tar -xzf ${modelData} -C $sourceRoot/data
  '';

  src = fetchFromGitHub {
    owner  = "libpinyin";
    repo   = "libpinyin";
    rev    = version;
    sha256 = "0jbvn65p3zh0573hh27aasd3qly5anyfi8jnps2dxi0my09wbrq3";
  };

  meta = with stdenv.lib; {
    description = "Library for intelligent sentence-based Chinese pinyin input method";
    homepage    = https://sourceforge.net/projects/libpinyin;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ ericsagnes ];
    platforms   = platforms.linux;
  };
}
