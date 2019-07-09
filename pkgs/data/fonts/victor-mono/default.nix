{ lib, fetchzip }:

let
  version = "1.2.1";
in fetchzip rec {
  name = "victor-mono-${version}";

  url = "https://github.com/rubjo/victor-mono/archive/v1.2.1.zip";

  # Grab VictorMonoAll.zip via versioned zip from github,
  # instead of unversioned URL on main website.
  # (they currently hash the same, happily)
  postFetch = ''
  unzip -j $downloadedFile \*/public/VictorMonoAll.zip

  mkdir -p $out/share/fonts

  unzip -j VictorMonoAll.zip \*.ttf -d $out/share/fonts/truetype
  unzip -j VictorMonoAll.zip \*.otf -d $out/share/fonts/opentype
  '';
  sha256 = "0gnnymvgc2qm8wl1dyha1ilpwr1c5bz8xy8jxg1kz0m61kr16xac";

  meta = with lib; {
    description = "Free programming font with cursive italics and ligatures";
    homepage = https://rubjo.github.io/victor-mono/;
    maintainers = with maintainers; [ dtzWill ];
    license = licenses.mit; # see LICENSE.txt in unpacked zip
    platforms = platforms.all;
  };
}

