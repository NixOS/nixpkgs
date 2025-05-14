{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "victor-mono";
  version = "1.5.6";

  # Upstream prefers we download from the website,
  # but we really insist on a more versioned resource.
  # Happily, tagged releases on github contain the same
  # file `VictorMonoAll.zip` as from the website,
  # so we extract it from the tagged release.
  # Both methods produce the same file, but this way
  # we can safely reason about what version it is.
  src = fetchzip {
    url = "https://github.com/rubjo/victor-mono/raw/v${version}/public/VictorMonoAll.zip";
    stripRoot = false;
    hash = "sha256-PnCCU7PO+XcxUk445sU5xVl8XqdSPJighjtDTqI6qiw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/fonts/"

    mv OTF $out/share/fonts/opentype
    mv TTF $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Free programming font with cursive italics and ligatures";
    homepage = "https://rubjo.github.io/victor-mono";
    license = licenses.ofl;
    maintainers = with maintainers; [ jpotier ];
    platforms = platforms.all;
  };
}
