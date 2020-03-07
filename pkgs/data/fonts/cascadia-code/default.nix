{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "cascadia-code";
  version = "1911.21";

  srcs = [
    (fetchurl {
      url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/Cascadia.ttf";
      sha256 = "1m5ymbngjg3n1g3p6vhcq7d825bwwln9afih651ar3jn7j9njnyg";
     })
    (fetchurl {
      url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/CascadiaMono.ttf";
      sha256 = "0vkhm6rhspzd1iayxrzaag099wsc94azfqa3ips7f4x9s8fmbp80";
    })
    (fetchurl {
      url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/CascadiaMonoPL.ttf";
      sha256 = "0xxqd8m2ydn97jngp1a3ik1mzpjbm65pfq02a82gfbbvajq5d673";
    })
    (fetchurl {
      url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/CascadiaPL.ttf";
      sha256 = "1s83c9flvifd05nbhnk8knwnik7p621sr7i94smknigc7d72wqav";
    })
  ];

  unpackCmd = ''
    ttfName=$(basename $(stripHash $curSrc))
    cp $curSrc ./$ttfName
  '';

  sourceRoot = ".";

  installPhase = ''
    install -Dm444 -t $out/share/fonts/truetype *.ttf
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1gkjs7qa409r4ykdy4ik8i0c3z49hzpklw6kyijhhifhyyyzhz4h";

  meta = with stdenv.lib; {
    description = "Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal";
    homepage = "https://github.com/microsoft/cascadia-code";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
