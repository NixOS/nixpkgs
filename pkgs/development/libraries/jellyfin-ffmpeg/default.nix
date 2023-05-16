<<<<<<< HEAD
{ ffmpeg_6-full
, nv-codec-headers-12
=======
{ ffmpeg_5-full
, nv-codec-headers-11
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, chromaprint
, fetchFromGitHub
, lib
}:

<<<<<<< HEAD
(ffmpeg_6-full.override {
  nv-codec-headers-11 = nv-codec-headers-12;
}).overrideAttrs (old: rec {
  pname = "jellyfin-ffmpeg";
  version = "6.0-6";
=======
(ffmpeg_5-full.override {
  nv-codec-headers = nv-codec-headers-11;
}).overrideAttrs (old: rec {
  pname = "jellyfin-ffmpeg";
  version = "5.1.2-8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-ffmpeg";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-jOKVS+BMADS/jIagOnYwxeGTpTMySmGlOHkPD2LJdkA=";
=======
    sha256 = "sha256-0ne9Xj9MnB5WOkPRtPX7W30qG1osHd0tyua+5RMrnQc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
