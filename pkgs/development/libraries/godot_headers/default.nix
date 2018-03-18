{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "godot_headers";
  version = "2018-02-09";
  src = fetchFromGitHub {
    owner = "GodotNativeTools";
    repo = "godot_headers";
    rev = "51bca3bf5d917341f3e15076c5a9191f8a5118ae";
    sha256 = "0z562pqm8y8wldmfiya72cvwwpvcfznpl0wypagw50v0f41ilywh";
  };
  buildPhase = "true";
  installPhase = ''
    mkdir $out
    cp -r . $out/include
  '';
  meta = {
    homepage = "https://github.com/GodotNativeTools/godot_headers/";
    description = "Headers for the Godot API supplied by the GDNative module";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.twey ];
  };
}
