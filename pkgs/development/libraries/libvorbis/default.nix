{ stdenv, fetchurl, libogg, pkgconfig, fetchpatch }:

stdenv.mkDerivation rec {
  name = "libvorbis-1.3.5";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/vorbis/${name}.tar.xz";
    sha256 = "1lg1n3a6r41492r7in0fpvzc7909mc5ir9z0gd3qh2pz4yalmyal";
  };

  outputs = [ "out" "dev" "doc" ];

  patches = [
    (fetchpatch {
      url = "https://github.com/xiph/vorbis/commit/a79ec216cd119069c68b8f3542c6a425a74ab993.patch";
      sha256 = "0xhsa96n3dlh2l85bxpz4b9m78mfxfgi2ibhjp77110a0nvkjr6h";
      name = "CVE-2017-14633";
    })
    (fetchpatch {
      url = "https://github.com/xiph/vorbis/commit/c1c2831fc7306d5fbd7bc800324efd12b28d327f.patch";
      sha256 = "17lb86105im6fc0h0cx5sn94p004jsdbbs2vj1m9ll6z9yb4rxwc";
      name = "CVE-2017-14632";
    })
    (fetchpatch {
      url = "https://gitlab.xiph.org/xiph/vorbis/uploads/a68cf70fa10c8081a633f77b5c6576b7/0001-CVE-2017-14160-make-sure-we-don-t-overflow.patch";
      sha256 = "0v21p59cb3z77ch1v6q5dcrd733h91f3m8ifnd7kkkr8gzn17d5x";
      name = "CVE-2017-14160";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ libogg ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://xiph.org/vorbis/;
    license = licenses.bsd3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
