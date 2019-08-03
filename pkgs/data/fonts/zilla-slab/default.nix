{ lib, fetchzip }:

let
  version = "1.002";
in fetchzip {
  name = "zilla-slab-${version}";

  url = "https://github.com/mozilla/zilla-slab/releases/download/v${version}/Zilla-Slab-Fonts-v${version}.zip";
  postFetch = ''
    unzip $downloadedFile
    mkdir -p $out/share/fonts/truetype
    cp -v zilla-slab/ttf/*.ttf $out/share/fonts/truetype/
  '';
  sha256 = "1b1ys28hyjcl4qwbnsyi6527nj01g3d6id9jl23fv6f8fjm4ph0f";

  meta = with lib; {
    homepage = https://github.com/mozilla/zilla-slab;
    description = "Zilla Slab fonts";
    longDescription = ''
      Zilla Slab is Mozilla's core typeface, used
      for the Mozilla wordmark, headlines and
      throughout their designs. A contemporary
      slab serif, based on Typotheque's Tesla, it
      is constructed with smooth curves and true
      italics, which gives text an unexpectedly
      sophisticated industrial look and a friendly
      approachability in all weights.
    '';
    license = licenses.ofl;
    maintainers = with maintainers; [ caugner ];
    platforms = platforms.all;
  };
}
