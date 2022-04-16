{ ffmpeg_4, ffmpeg-full, fetchFromGitHub, lib }:

(ffmpeg-full.override { ffmpeg = ffmpeg_4; }).overrideAttrs (old: rec {
  name = "jellyfin-ffmpeg";
  version = "4.4.1-4";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-ffmpeg";
    rev = "v${version}";
    sha256 = "0y7iskamlx30f0zknbscpi308y685nbnbf5gr9cj1znr5dlfb0bn";
  };

  postPatch = ''
    for file in $(cat debian/patches/series); do
      patch -p1 < debian/patches/$file
    done

    ${old.postPatch or ""}
  '';

  doCheck = false; # https://github.com/jellyfin/jellyfin-ffmpeg/issues/79

  meta = with lib; {
    description = "${old.meta.description} (Jellyfin fork)";
    homepage = "https://github.com/jellyfin/jellyfin-ffmpeg";
    license = licenses.gpl3;
    maintainers = with maintainers; [ justinas ];
  };
})
