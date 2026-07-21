{
  lib,
  stdenv,
  fetchFromGitHub,
  tt-rss,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tt-rss-plugin-feediron";
  version = "1.33";

  src = fetchFromGitHub {
    owner = "feediron";
    repo = "ttrss_plugin-feediron";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-KU4XQJNK7Ua7rZaXA32lv16RlloCysAb54E5kEY847A=";
  };

  installPhase = ''
    mkdir -p $out/feediron

    cp -r bin filters init.php preftab recipes $out/feediron/
  '';

  meta = {
    description = "Evolution of ttrss_plugin-af_feedmod";
    longDescription = ''
      This is a plugin for Tiny Tiny RSS (tt-rss).
      It allows you to replace an article's contents by the contents of an element on the linked URL's page

      i.e. create a "full feed".
    '';
    license = lib.licenses.mit;
    homepage = "https://github.com/feediron/ttrss_plugin-feediron";
    maintainers = with lib.maintainers; [ milogert ];
    inherit (tt-rss.meta) platforms;
  };
})
