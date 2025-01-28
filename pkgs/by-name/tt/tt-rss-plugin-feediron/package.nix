{
  lib,
  stdenv,
  fetchFromGitHub,
  tt-rss,
}:

stdenv.mkDerivation rec {
  pname = "tt-rss-plugin-feediron";
  version = "1.32-unstable-2024-05-04";

  src = fetchFromGitHub {
    owner = "feediron";
    repo = "ttrss_plugin-feediron";
    rev = "8ac460ee7156465eaad0323d6c68e84058f9ef1c";
    sha256 = "sha256-kyE9okddxQu1cETf6xCSpmaZV5UmqDB4Sq7boNOBY3o=";
  };

  installPhase = ''
    mkdir -p $out/feediron

    cp -r bin filters init.php preftab recipes $out/feediron/
  '';

  meta = with lib; {
    description = "Evolution of ttrss_plugin-af_feedmod";
    longDescription = ''
      This is a plugin for Tiny Tiny RSS (tt-rss).
      It allows you to replace an article's contents by the contents of an element on the linked URL's page

      i.e. create a "full feed".
    '';
    license = licenses.mit;
    homepage = "https://github.com/feediron/ttrss_plugin-feediron";
    maintainers = with maintainers; [ milogert ];
    inherit (tt-rss.meta) platforms;
  };
}
