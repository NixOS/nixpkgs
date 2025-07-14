{
  lib,
  stdenv,
  fetchFromGitHub,
  tt-rss,
}:

stdenv.mkDerivation {
  pname = "tt-rss-plugin-markasread";
  version = "unstable-2022-07-05";

  src = fetchFromGitHub {
    owner = "Elv1zz";
    repo = "ttrss_plugin-markasread";
    rev = "7aa64334689869320ff9635e05221705b4ad136b";
    sha256 = "sha256-IDCwlxWIchfIq4KmpCF6plFuM+BNQtDS0s8fkwwNqCQ=";
  };

  installPhase = ''
    mkdir -p $out/markasread

    cp init.php markasread.css markasread.js *.png $out/markasread/
  '';

  meta = with lib; {
    description = "Google Reader like 'Mark as read' checkbox for Tiny Tiny RSS";
    longDescription = ''
      This plugin for Tiny Tiny RSS (tt-rss) adds a checkbox in the article
      footer to mark an article as read and unread just like in discontinued
      Google Reader.
    '';
    license = licenses.free; # No explicit license found in repository
    homepage = "https://github.com/Elv1zz/ttrss_plugin-markasread";
    maintainers = with maintainers; [ lostmsu ];
    inherit (tt-rss.meta) platforms;
  };
}
