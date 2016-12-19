{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "libre-baskerville-1.000";

  src = fetchFromGitHub {
    owner = "impallari";
    repo = "Libre-Baskerville";
    rev = "2fba7c8e0a8f53f86efd3d81bc4c63674b0c613f";
    sha256 = "0i9ra6ip81zzjxl71p8zwa6ymlmkf4yi5ny22vlwx9a53kbf4ifl";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/${name}
    cp -v *.ttf $out/share/fonts/truetype/
    cp -v README.md FONTLOG.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    description = "A webfont family optimized for body text";
    longDescription = ''
      Libre Baskerville is a webfont family optimized for body text. It's Based
      on 1941 ATF Baskerville Specimens but it has a taller x-height, wider
      counters and less contrast that allow it to work on small sizes in any
      screen.
    '';
    homepage = http://www.impallari.com/projects/overview/libre-baskerville;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
