{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, fuse, adb }:

stdenv.mkDerivation rec {
  name = "adbfs-rootless-${version}";
  version = "2016-10-02";

  src = fetchFromGitHub {
    owner = "spion";
    repo = "adbfs-rootless";
    rev = "b58963430e40c9246710a16cec58e7ffc88baa48";
    sha256 = "1kjibl86k6pf7vciwaaxwv5m4q28zdpd2g7yhp71av32jq6j3wm8";
  };

  patches = [
    (fetchpatch {
      # https://github.com/spion/adbfs-rootless/issues/14
      url = "https://github.com/kronenpj/adbfs-rootless/commit/35f87ce0a7aeddaaad118daed3022e01453b838d.patch";
      sha256 = "1iigla74n3hphnyx9ffli9wqk7v71ylvsxama868czlg7851jqj9";
    })
  ];

  buildInputs = [ fuse pkgconfig ];

  postPatch = ''
    # very ugly way of replacing the adb calls
    sed -e 's|"adb |"${stdenv.lib.getBin adb}/bin/adb |g' \
        -i adbfs.cpp
  '';

  installPhase = ''
    install -D adbfs $out/bin/adbfs
  '';

  meta = with stdenv.lib; {
    description = "Mount Android phones on Linux with adb, no root required";
    inherit (src.meta) homepage;
    license = licenses.bsd3;
    maintainers = with maintainers; [ profpatsch ];
    platforms = platforms.linux;
  };
}
