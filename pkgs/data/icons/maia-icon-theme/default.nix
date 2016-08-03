{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "maia-icon-theme";

  src = fetchFromGitHub {
    owner = "manjaro";
    repo = "artwork-maia";
    rev = "23235fa56e6111d30e9f92576030cc855a0facbe";
    sha256 = "1d5bv13gds1nx88pc6a9gkrz1lb8sji0wcc5h3bf4mjw0q072nfr";
  };

  dontBuild = true;
  
  installPhase = ''
    install -dm 755 $out/share/icons
    rm icons/CMakeLists.txt
    cp -dr --no-preserve='ownership' icons $out/share/icons/Maia
  '';

  meta = with stdenv.lib; {
    description = "Icons based on Breeze and Super Flat Remix";
    homepage = https://github.com/manjaro/artwork-maia;
    licence = licenses.free;
    maintainers = [ maintainers.mounium ];
    platforms = platforms.all;
  };
}
