{ ffmpeg_6-full
, fetchFromGitHub
, fetchpatch
, lib
}:

let
  version = "6.0.1-6";
in

(ffmpeg_6-full.override {
  inherit version; # Important! This sets the ABI.
  source = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-ffmpeg";
    rev = "v${version}";
    hash = "sha256-jy5LPurjuSIMZlzVZcuaqAwAZunbYc9/6aJf+hna0Kw=";
  };
}).overrideAttrs (old: {
  pname = "jellyfin-ffmpeg";

  # Clobber upstream patches as they don't apply to the Jellyfin fork
  patches = [
    (fetchpatch {
      name = "fix_build_failure_due_to_libjxl_version_to_new";
      url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/75b1a555a70c178a9166629e43ec2f6250219eb2";
      hash = "sha256-+2kzfPJf5piim+DqEgDuVEEX5HLwRsxq0dWONJ4ACrU=";
    })
  ];

  configureFlags = old.configureFlags ++ [
    "--extra-version=Jellyfin"
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
    pkgConfigModules = [ "libavutil" ];
  };
})
