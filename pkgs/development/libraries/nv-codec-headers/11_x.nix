{ stdenv
, lib
, fetchgit
}:

stdenv.mkDerivation rec {
  pname = "nv-codec-headers";
  version = "11.1.5.2";

  src = fetchgit {
    url = "https://git.videolan.org/git/ffmpeg/nv-codec-headers.git";
    rev = "n${version}";
    sha256 = "sha256-KzaqwpzISHB7tSTruynEOJmSlJnAFK2h7/cRI/zkNPk=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "FFmpeg version of headers for NVENC";
    homepage = "https://git.videolan.org/?p=ffmpeg/nv-codec-headers.git";
    license = licenses.mit;
    maintainers = with maintainers; [ MP2E ];
    platforms = platforms.all;
  };
}
