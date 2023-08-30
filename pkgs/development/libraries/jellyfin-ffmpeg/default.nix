{ ffmpeg_6-full
, nv-codec-headers-12
, chromaprint
, fetchFromGitHub
, lib
}:

(ffmpeg_6-full.override {
  nv-codec-headers-11 = nv-codec-headers-12;
}).overrideAttrs (old: rec {
  pname = "jellyfin-ffmpeg";
  version = "6.0-5";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-ffmpeg";
    rev = "v${version}";
    sha256 = "sha256-pKmR+IVJAaY91KiboCBkwZleMmMFToez1fW+eXyrZjs=";
  };

  buildInputs = old.buildInputs ++ [ chromaprint ];

  configureFlags = old.configureFlags ++ [
    "--extra-version=Jellyfin"
    "--disable-ptx-compression" # https://github.com/jellyfin/jellyfin/issues/7944#issuecomment-1156880067
    "--enable-chromaprint"
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
