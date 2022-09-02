{ ffmpeg_5-full
, nv-codec-headers-11
, fetchFromGitHub
, lib
, fetchpatch
}:

(ffmpeg_5-full.override {
  nv-codec-headers = nv-codec-headers-11;
}).overrideAttrs (old: rec {
  pname = "jellyfin-ffmpeg";
  version = "5.1-2";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-ffmpeg";
    rev = "v${version}";
    sha256 = "sha256-lw2W65mbBhiSnegxLSRqDz2WMM82ght/KB4i+5BiL4o=";
  };

  configureFlags = old.configureFlags ++ [
    "--disable-ptx-compression" # https://github.com/jellyfin/jellyfin/issues/7944#issuecomment-1156880067
  ];

  patches = old.patches ++ [
    # fixed in upstream ffmpeg 5.1.1 https://trac.ffmpeg.org/ticket/9841
    (fetchpatch {
      name = "rename-imf-fate-target.patch";
      url = "https://github.com/FFmpeg/FFmpeg/commit/80d1b8938eb227f0e9efde91050836b1e9a051a9.patch";
      sha256 = "sha256-weUbLKSQ9iRYSQ3hgXcVpo8jfKajpXK21qD1GrZYHYQ=";
    })
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
