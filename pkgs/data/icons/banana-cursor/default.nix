{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "banana-cursor";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "banana-cursor";
    rev = "v${version}";
    sha256 = "sha256-PI7381xf/GctQTnfcE0W3M3z2kqbX4VexMf17C61hT8=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/icons
    mv themes/Banana $out/share/icons
  '';

  meta = with lib; {
    homepage = "https://github.com/ful1e5/banana-cursor";
    description = "The banana cursor theme";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yrd ];
  };
}
