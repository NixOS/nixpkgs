{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "maia-icon-theme-${version}";
  version = "2016-09-16";

  src = fetchFromGitHub {
    owner = "manjaro";
    repo = "artwork-maia";
    rev = "f6718cd9c383adb77af54b694c47efa4d581f5b5";
    sha256 = "0f9l3k9abgg8islzddrxgbxaw6vbai5bvz5qi1v2fzir7ykx7bgj";
  };

  dontBuild = true;
  
  installPhase = ''
    install -dm 755 $out/share/icons
    for f in "" "-dark"; do
      rm icons$f/CMakeLists.txt
      cp -dr --no-preserve='ownership' icons$f $out/share/icons/maia$f
    done
  '';

  meta = with stdenv.lib; {
    description = "Icons based on Breeze and Super Flat Remix";
    homepage = https://github.com/manjaro/artwork-maia;
    license = licenses.free;
    maintainers = [ maintainers.mounium ];
    platforms = platforms.all;
  };
}
