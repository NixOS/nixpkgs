{ lib, stdenv, fetchurl, pkg-config, icu, clucene_core, curl }:

stdenv.mkDerivation rec {

  pname = "sword";
  version = "1.8.1";

  src = fetchurl {
    url = "https://www.crosswire.org/ftpmirror/pub/sword/source/v1.8/${pname}-${version}.tar.gz";
    sha256 = "14syphc47g6svkbg018nrsgq4z6hid1zydax243g8dx747vsi6nf";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ icu clucene_core curl ];

  prePatch = ''
    patchShebangs .;
  '';

  configureFlags = [ "--without-conf" "--enable-tests=no" ];
  CXXFLAGS = [
    "-Wno-unused-but-set-variable"
    # compat with icu61+ https://github.com/unicode-org/icu/blob/release-64-2/icu4c/readme.html#L554
    "-DU_USING_ICU_NAMESPACE=1"
  ];

  meta = with lib; {
    description = "A software framework that allows research manipulation of Biblical texts";
    homepage = "http://www.crosswire.org/sword/";
    longDescription = ''
      The SWORD Project is the CrossWire Bible Society's free Bible software
      project. Its purpose is to create cross-platform open-source tools --
      covered by the GNU General Public License -- that allow programmers and
      Bible societies to write new Bible software more quickly and easily. We
      also create Bible study software for all readers, students, scholars, and
      translators of the Bible, and have a growing collection of many hundred
      texts in around 100 languages.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };

}
