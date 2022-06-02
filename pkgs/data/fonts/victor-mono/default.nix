{ lib, fetchzip }:

let
  version = "1.5.3";
in
fetchzip {
  name = "victor-mono-${version}";
  stripRoot = false;

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
    cp --recursive $out/OTF $out/share/fonts/opentype
    cp --recursive $out/TTF $out/share/fonts/truetype
  '';

  sha256 = "sha256-vqsVD5GEzcBoYCCJU7b+ie/cHS2DarIBaGAZZEGSo+A=";

  meta = with lib; {
    description = "Free programming font with cursive italics and ligatures";
    homepage = "https://rubjo.github.io/victor-mono";
    license = licenses.ofl;
    maintainers = with maintainers; [ jpotier dtzWill ];
    platforms = platforms.all;
  };
}
