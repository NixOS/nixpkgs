{ lib, fetchzip }:

let
  version = "1.5.2";
in
fetchzip {
  name = "victor-mono-${version}";

  # Upstream prefers we download from the website,
  # but we really insist on a more versioned resource.
  # Happily, tagged releases on github contain the same
  # file `VictorMonoAll.zip` as from the website,
  # so we extract it from the tagged release.
  # Both methods produce the same file, but this way
  # we can safely reason about what version it is.
  url = "https://github.com/rubjo/victor-mono/raw/v${version}/public/VictorMonoAll.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  sha256 = "sha256-cNDZh0P/enmoKL/6eHzkgl5ghtai2K9cTgWMVmm8GIA=";

  meta = with lib; {
    description = "Free programming font with cursive italics and ligatures";
    homepage = "https://rubjo.github.io/victor-mono";
    license = licenses.ofl;
    maintainers = with maintainers; [ jpotier dtzWill ];
    platforms = platforms.all;
  };
}
