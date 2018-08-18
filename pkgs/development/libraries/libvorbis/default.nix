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
      url = "https://gitlab.xiph.org/xiph/vorbis/uploads/a68cf70fa10c8081a633f77b5c6576b7/0001-CVE-2017-14160-make-sure-we-don-t-overflow.patch";
      sha256 = "0v21p59cb3z77ch1v6q5dcrd733h91f3m8ifnd7kkkr8gzn17d5x";
      name = "CVE-2017-14160";
    })
    (fetchpatch {
      url = "https://gitlab.xiph.org/xiph/vorbis/commit/112d3bd0aaa.diff";
      sha256 = "1k77y3q36npy8mkkz40f6cb46l2ldrwyrd191m29s8rnbhnafdf7";
      name = "CVE-2018-10392.patch";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ libogg ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://xiph.org/vorbis/;
    license = licenses.bsd3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
