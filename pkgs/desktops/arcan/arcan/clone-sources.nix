{ fetchgit, fetchFromGitHub }:
{
  letoram-openal-src = fetchFromGitHub {
    owner = "letoram";
    repo = "openal";
    rev = "81e1b364339b6aa2b183f39fc16c55eb5857e97a";
    sha256 = "sha256-X3C3TDZPiOhdZdpApC4h4KeBiWFMxkFsmE3gQ1Rz420=";
  };
  freetype-src = fetchgit {
    url = "git://git.sv.nongnu.org/freetype/freetype2.git";
    rev = "275b116b40c9d183d42242099ea9ff276985855b";
    sha256 = "sha256-YVyJttaXt19MSuD0pmazwxNKz65jcqqWvIgmDj4d3MA=";
  };
  libuvc-src = fetchFromGitHub {
    owner = "libuvc";
    repo = "libuvc";
    rev = "a4de53e7e265f8c6a64df7ccd289f318104e1916";
    hash = "sha256-a+Q0PTV4ujGnX55u49VJfMgQljZunZYRvkR0tIkGnHI=";
  };
  luajit-src = fetchgit {
    url = "https://luajit.org/git/luajit-2.0.git";
    rev = "899093a9e0fa5b16f27016381ef4b15529dadff2";
    sha256 = "sha256-bCi1ms78HCOOgStIY2tSGM9LUEX3qnwadLLeYWWu1KI=";
  };
}
