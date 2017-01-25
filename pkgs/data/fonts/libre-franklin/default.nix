{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "libre-franklin-1.014";

  src = fetchFromGitHub {
    owner = "impallari";
    repo = "Libre-Franklin";
    rev = "006293f34c47bd752fdcf91807510bc3f91a0bd3";
    sha256 = "0df41cqhw5dz3g641n4nd2jlqjf5m4fkv067afk3759m4hg4l78r";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}
    cp -v "fonts/OTF/"*.otf $out/share/fonts/opentype/
    cp -v README.md FONTLOG.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    description = "A reinterpretation and expansion based on the 1912 Morris Fuller Benton’s classic.";
    homepage = https://github.com/impallari/Libre-Franklin;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
