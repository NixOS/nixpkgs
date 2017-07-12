{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dotsies";

  regular = fetchurl {
    name = "dotsies-regular";
    url = "http://dotsies.org/Dotsies.ttf";
    sha256 = "0cg0ay1524k178rzaipx6nw7pv15ibwynpx2w4lp8h9xb10k40nn";
  };

  training-wheels = fetchurl {
    name = "dotsies-training-wheel";
    url = "http://dotsies.org/Dotsies%20Training%20Wheels.ttf";
    sha256 = "10igqaw5c7a50vcyfnfm66bgx5vl4chb8a6kd9vsinpr2mc5ywnm";
  };

  wide = fetchurl {
    name = "dotsies-wide";
    url = "http://dotsies.org/Dotsies%20Wide.ttf";
    sha256 = "0xpn0b5mvmilr3llmg0qf6a9dip4nwzllkzdg5svpz15i3kb2x39";
  };

  context = fetchurl {
    name = "dotsies-context";
    url = "http://dotsies.org/Dotsies%20Context.ttf";
    sha256 = "11z834ipcfv7xp9znp1afsfgahbi5vgp863izlkksylp2wgm52dp";
  };

  striped = fetchurl {
    name = "dotsies-striped";
    url = "http://dotsies.org/Dotsies%20Striped.ttf";
    sha256 = "1yf3b44ipi4fyvr56ac7bbm9id70bgsv63wr2iz4xc8a8wr18sli";
  };

  roman = fetchurl {
    name = "dotsies-roman";
    url = "http://dotsies.org/Dotsies%20Roman.ttf";
    sha256 = "11n11m7wpnqa72i4dh7qx4lnpd183mljm1ir8asyncyvll1x2a5i";
  };

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp ${regular} $out/share/fonts/truetype/Dotsies.ttf
    cp ${training-wheels} $out/share/fonts/truetype/Dotsies\ Training\ Wheels.ttf
    cp ${wide} $out/share/fonts/truetype/Dotsies\ Wide.ttf
    cp ${context} $out/share/fonts/truetype/Dotsies\ Context.ttf
    cp ${striped} $out/share/fonts/truetype/Dotsies\ Striped.ttf
    cp ${roman} $out/share/fonts/truetype/Dotsies\ Roman.ttf
  '';

  meta = with stdenv.lib; {
    homepage = http://dotsies.org/;
    description = "Dotsies is a font that uses dots instead of letters.";
    longDescription = ''
      Dotsies is a font that uses dots instead of letters. Dotsies is optimized for reading. The letters in each word smoosh together, so words look like shapes.
    '';
    license = with licenses; [ unfree ];
    platforms = platforms.all;
  };
}
