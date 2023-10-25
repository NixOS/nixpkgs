{ stdenv
, lib
, fetchgit
}:

stdenv.mkDerivation rec {
  pname = "nv-codec-headers";
  version = "12.0.16.0";

  src = fetchgit {
    url = "https://git.videolan.org/git/ffmpeg/nv-codec-headers.git";
    rev = "n${version}";
    sha256 = "sha256-8YZU9pb0kzat0JBVEotaZUkNicQvLNIrIyPU9KTTjwg=";
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
