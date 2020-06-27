{ lib, mkFont, fetchurl }:

mkFont rec {
  pname = "cascadia-code";
  version = "1911.21";

  srcs = map fetchurl [
    {
      url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/Cascadia.ttf";
      sha256 = "1m5ymbngjg3n1g3p6vhcq7d825bwwln9afih651ar3jn7j9njnyg";
    }
    {
      url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/CascadiaMono.ttf";
      sha256 = "0vkhm6rhspzd1iayxrzaag099wsc94azfqa3ips7f4x9s8fmbp80";
    }
    {
      url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/CascadiaMonoPL.ttf";
      sha256 = "0xxqd8m2ydn97jngp1a3ik1mzpjbm65pfq02a82gfbbvajq5d673";
    }
    {
      url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/CascadiaPL.ttf";
      sha256 = "1s83c9flvifd05nbhnk8knwnik7p621sr7i94smknigc7d72wqav";
    }
  ];

  noUnpackFonts = true;

  meta = with lib; {
    description = "Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal";
    homepage = "https://github.com/microsoft/cascadia-code";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
