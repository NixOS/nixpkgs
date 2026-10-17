{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "tt-rss-plugin-ff-instagram";
  version = "0-unstable-2019-01-10"; # No release, see https://github.com/wltb/ff_instagram/issues/6

  src = fetchFromGitHub {
    owner = "wltb";
    repo = "ff_instagram";
    rev = "0366ffb18c4d490c8fbfba2f5f3367a5af23cfe8";
    hash = "sha256-cwfVlrFO/pu9DW2I1ML/0T395GS7NaftxLlKE7mhf28=";
  };

  installPhase = ''
    mkdir -p $out/ff_instagram

    cp *.php $out/ff_instagram
  '';

  meta = {
    broken = true; # Plugin code does not conform to plugin API changes. See https://github.com/wltb/ff_instagram/issues/13
    description = "Plugin for Tiny Tiny RSS that allows to fetch posts from Instagram user sites";
    longDescription = ''
      Plugin for Tiny Tiny RSS that allows to fetch posts from Instagram user sites.

      The name of the plugin in TT-RSS is 'ff_instagram'.
    '';
    license = lib.licenses.agpl3Plus;
    homepage = "https://github.com/wltb/ff_instagram";
    maintainers = with lib.maintainers; [ gileri ];
    platforms = lib.platforms.all;
  };
}
