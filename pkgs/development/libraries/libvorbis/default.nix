{ stdenv, fetchurl, libogg, pkgconfig, fetchpatch }:

stdenv.mkDerivation rec {
  name = "libvorbis-1.3.6";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/vorbis/${name}.tar.xz";
    sha256 = "05dlzjkdpv46zb837wysxqyn8l636x3dw8v8ymlrwz2fg1dbn05g";
  };

  outputs = [ "out" "dev" "doc" ];

  patches = [
    (fetchpatch {
      url = "https://gitlab.xiph.org/xiph/vorbis/commit/018ca26dece618457dd13585cad52941193c4a25.patch";
      sha256 = "18k4vp0nmrxxpis641ylnw6dgwxrymh5bf74njr6v8dizmmz1bkj";
      name = "CVE-2017-14160+CVE-2018-10393.patch";
    })
    (fetchpatch {
      url = "https://gitlab.xiph.org/xiph/vorbis/commit/112d3bd0aaacad51305e1464d4b381dabad0e88b.diff";
      sha256 = "1k77y3q36npy8mkkz40f6cb46l2ldrwyrd191m29s8rnbhnafdf7";
      name = "CVE-2018-10392.patch";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ libogg ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Vorbis audio compression reference implementation";
    homepage = "https://xiph.org/vorbis/";
    license = licenses.bsd3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
