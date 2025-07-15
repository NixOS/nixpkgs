{
  lib,
  stdenv,
  fetchFromGitHub,
  tt-rss,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tt-rss-plugin-markasread";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "Elv1zz";
    repo = "ttrss_plugin-markasread";
    tag = finalAttrs.version;
    hash = "sha256-IDCwlxWIchfIq4KmpCF6plFuM+BNQtDS0s8fkwwNqCQ=";
  };

  installPhase = ''
    mkdir -p $out/markasread

    cp init.php markasread.css markasread.js *.png $out/markasread/
  '';

  meta = {
    description = "Google Reader like 'Mark as read' checkbox for Tiny Tiny RSS";
    longDescription = ''
      This plugin for Tiny Tiny RSS (tt-rss) adds a checkbox in the article
      footer to mark an article as read and unread just like in discontinued
      Google Reader.
    '';
    license = lib.licenses.unfree; # No explicit license found in repository
    homepage = "https://github.com/Elv1zz/ttrss_plugin-markasread";
    maintainers = with lib.maintainers; [ lostmsu ];
    inherit (tt-rss.meta) platforms;
  };
})
