{ stdenv, fetchurl, fetchFromGitHub, autoreconfHook, glib, db, pkgconfig }:

let
  modelData = fetchurl {
    url    = "mirror://sourceforge/libpinyin/models/model12.text.tar.gz";
    sha256 = "1fijhhnjgj8bj1xr5pp7c4qxf11cqybgfqg7v36l3x780d84hfnd";
  };
in

stdenv.mkDerivation rec {
  name = "libpinyin-${version}";
  version = "1.6.0";

  nativeBuildInputs = [ autoreconfHook glib db pkgconfig ];

  postUnpack = ''
    tar -xzf ${modelData} -C $sourceRoot/data
  '';

  src = fetchFromGitHub {
    owner  = "libpinyin";
    repo   = "libpinyin";
    rev    = version;
    sha256 = "0k40a7wfp8zj9d426afv0am5sr3m2i2p309fq0vf8qrb050hj17f";
  };

  meta = with stdenv.lib; {
    description = "Library for intelligent sentence-based Chinese pinyin input method";
    homepage    = https://sourceforge.net/projects/libpinyin;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ ericsagnes ];
    platforms   = platforms.linux;
  };
}
