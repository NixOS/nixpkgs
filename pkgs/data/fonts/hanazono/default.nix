{ lib, fetchzip }:

let
  version = "20170904";
in fetchzip {
  name = "hanazono-${version}";

  url = "mirror://osdn/hanazono-font/68253/hanazono-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.txt -d $out/share/doc/hanazono
  '';

  sha256 = "0qiyd1vk3w8kqmwc6xi5d390wdr4ln8xhfbx3n8r1hhad9iz14p6";

  meta = with lib; {
    description = "Japanese Mincho-typeface TrueType font";
    homepage = "https://fonts.jp/hanazono/";
    longDescription = ''
      Hanazono Mincho typeface is a Japanese TrueType font that developed with a
      support of Grant-in-Aid for Publication of Scientific Research Results
      from Japan Society for the Promotion of Science and the International
      Research Institute for Zen Buddhism (IRIZ), Hanazono University. also with
      volunteers who work together on glyphwiki.org.
    '';

    # Dual-licensed under OFL and the following:
    # This font is a free software.
    # Unlimited permission is granted to use, copy, and distribute it, with
    # or without modification, either commercially and noncommercially.
    # THIS FONT IS PROVIDED "AS IS" WITHOUT WARRANTY.
    license = [ licenses.ofl licenses.free ];
    maintainers = with maintainers; [ mathnerd314 ];
    platforms = platforms.all;
  };
}
