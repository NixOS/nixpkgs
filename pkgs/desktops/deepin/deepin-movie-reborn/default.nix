{ stdenv, mkDerivation, fetchFromGitHub, fetchpatch, cmake, pkgconfig, qttools, qtx11extras,
  dtkcore, dtkwidget, ffmpeg, ffmpegthumbnailer, mpv, pulseaudio,
  libdvdnav, libdvdread, xorg, deepin }:

mkDerivation rec {
  pname = "deepin-movie-reborn";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0cly8q0514a58s3h3wsvx9yxar7flz6i2q8xkrkfjias22b3z7b0";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    pkgconfig
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    dtkcore
    dtkwidget
    ffmpeg
    ffmpegthumbnailer
    libdvdnav
    libdvdread
    mpv
    pulseaudio
    qtx11extras
    xorg.libXdmcp
    xorg.libXtst
    xorg.libpthreadstubs
    xorg.xcbproto
  ];

  patches = [
    # fix: build failed if cannot find dtk-settings tool
    (fetchpatch {
      url = "https://github.com/linuxdeepin/deepin-movie-reborn/commit/fbb307b.patch";
      sha256 = "0915za0khki0729rvcfpxkh6vxhqwc47cgcmjc90kfq1004221vx";
    })
  ];

  NIX_LDFLAGS = "-ldvdnav";


  postPatch = ''
    searchHardCodedPaths  # debugging

    sed -i src/libdmr/libdmr.pc.in -e "s,/usr,$out," -e 's,libdir=''${prefix}/,libdir=,'

    substituteInPlace src/deepin-movie.desktop \
      --replace "Exec=deepin-movie" "Exec=$out/bin/deepin-movie"
  '';

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Deepin movie player";
    homepage = https://github.com/linuxdeepin/deepin-movie-reborn;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
