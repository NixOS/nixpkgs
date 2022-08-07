{ ffmpeg_5-full
, nv-codec-headers-11
, fetchFromGitHub
, lib
}:

(ffmpeg_5-full.override {
  nv-codec-headers = nv-codec-headers-11;
}).overrideAttrs (old: rec {
  pname = "jellyfin-ffmpeg";
  version = "5.1-1";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-ffmpeg";
    rev = "v${version}";
    sha256 = "sha256-R3+SJ2RNaRRK6+N9eGOf/0qUgaXkT/cswkxf+7W2+Fo=";
  };

  configureFlags = old.configureFlags ++ [
    "--disable-ptx-compression" # https://github.com/jellyfin/jellyfin/issues/7944#issuecomment-1156880067
  ];

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
