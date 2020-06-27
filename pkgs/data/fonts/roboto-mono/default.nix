{ lib, mkFont, fetchurl }:

let
  # Latest commit touching the robotomono tree
  commit = "5338537ef835a3d9ccf8faf386399f13a30605e2";
in
mkFont {
  pname = "roboto-mono";
  version = "2.002-20190125";

  srcs = map fetchurl [
    {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-Regular.ttf";
      sha256 = "1f96r4by67hzqpr4p2wkrfnpj9b7x9qrmwns0312w2l2rnp2qajx";
    }
    {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-Bold.ttf";
      sha256 = "10wg4dchdq4s89r9pd4h8y5l1bf8mix32pksph2wafyr3815kfnm";
    }
    {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-Italic.ttf";
      sha256 = "1cayhm3wj36q748xd0zdgrhm4pz7wnrskrlf7khxx2s41m3win5b";
    }
    {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-BoldItalic.ttf";
      sha256 = "04238dxizdlhnnnyzhnqckxf8ciwlnwyzxby6qgpyg232abx0n2z";
    }
    {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-Medium.ttf";
      sha256 = "00rh49d0dbycbkjgd2883w7iqzd6hcry08ycjipsvk091p5nq6qy";
    }
    {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-MediumItalic.ttf";
      sha256 = "0fxl6lblj7anhqmhplnpvjwckjh4g8m6r9jykxdrvpl5hk8mr65b";
    }
    {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-Light.ttf";
      sha256 = "1h8rbc2p70fabkplsafzah1wcwy92qc1wzkmc1cnb4yq28gxah4a";
    }
    {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-LightItalic.ttf";
      sha256 = "08y2qngwy61mc22f8i00gshgmcf7hwmfxh1f4j824svy4n16zhsc";
    }
    {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-Thin.ttf";
      sha256 = "0fmij9zlfjiyf0vb8n8gvrwi35l830zpmkbhcy1xgx0m8za6mmmy";
    }
    {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotomono/RobotoMono-ThinItalic.ttf";
      sha256 = "0mpwdhjnsk8311nw8fqzy1b7v0wzb4pw639ply1j38a0vibrsmn7";
    }
  ];

  noUnpackFonts = true;

  meta = with lib; {
    homepage = "https://www.google.com/fonts/specimen/Roboto+Mono";
    description = "Google Roboto Mono fonts";
    longDescription = ''
      Roboto Mono is a monospaced addition to the Roboto type family. Like
      the other members of the Roboto family, the fonts are optimized for
      readability on screens across a wide variety of devices and reading
      environments. While the monospaced version is related to its variable
      width cousin, it doesn't hesitate to change forms to better fit the
      constraints of a monospaced environment. For example, narrow glyphs
      like 'I', 'l' and 'i' have added serifs for more even texture while
      wider glyphs are adjusted for weight. Curved caps like 'C' and 'O'
      take on the straighter sides from Roboto Condensed.
    '';
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
