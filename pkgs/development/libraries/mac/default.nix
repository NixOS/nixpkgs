{ lib, stdenv, fetchurl, fetchpatch, yasm }:

stdenv.mkDerivation rec {
  pname = "mac";
  version = "4.11-u4-b5-s7";

  src = fetchurl {
    url = "https://www.deb-multimedia.org/pool/main/m/monkeys-audio/monkeys-audio_${version}.orig.tar.gz";
    sha256 = "16i96cw5r3xbsivjigqp15vv32wa38k86mxq11qx1pzmpryqpqkk";
  };

  patches = [
    (fetchpatch {
      name = "mac-4.11.4.5.7-gcc6.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-sound/mac/files/mac-4.11.4.5.7-gcc6.patch?id=1bd4e0e30e4d8a8862217d7067323851b34c7fe4";
      sha256 = "093b8m8p8s6dmc62fc8vb4hlmjc2ncb4rdgc82g0a8gg6w5kcj8x";
    })
    (fetchpatch {
      name = "mac-4.11.4.5.7-output.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-sound/mac/files/mac-4.11.4.5.7-output.patch?id=1bd4e0e30e4d8a8862217d7067323851b34c7fe4";
      sha256 = "0njmwj6d9jqi4pz4fax02w37gk22vda0grszrs2nn97zzmjl36zk";
    })
  ];

  CXXFLAGS = "-DSHNTOOL";

  nativeBuildInputs = [ yasm ];

  meta = with lib; {
    description = "APE codec and decompressor";
    homepage = "https://www.deb-multimedia.org/dists/testing/main/binary-amd64/package/monkeys-audio.php";
    license = licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
  };
}
