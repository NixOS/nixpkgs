{ ffmpeg_5-full
, nv-codec-headers-11
, fetchFromGitHub
, lib
}:

(ffmpeg_5-full.override {
  nv-codec-headers = nv-codec-headers-11;
}).overrideAttrs (old: rec {
  pname = "jellyfin-ffmpeg";
  version = "5.0.1-8";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-ffmpeg";
    rev = "v${version}";
    sha256 = "sha256-zr1WuTkOBAVk7JkpDT52rfGGOaXEqiPFIGmJUDPhI/w=";
  };

  postPatch = ''
    for file in $(cat debian/patches/series); do
      patch -p1 < debian/patches/$file
    done

    ${old.postPatch or ""}
  '';

  meta = with lib; {
    description = "${old.meta.description} (Jellyfin fork)";
    homepage = "https://github.com/jellyfin/jellyfin-ffmpeg";
    license = licenses.gpl3;
    maintainers = with maintainers; [ justinas ];
  };
})
