{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "hermit";
  version = "2.0";

  src = fetchurl {
    url = "https://pcaro.es/d/otf-${pname}-${version}.tar.gz";
    sha256 = "09rmy3sbf1j1hr8zidighjgqc8kp0wsra115y27vrnlf10ml6jy0";
  };

  sourceRoot = ".";

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp *.otf $out/share/fonts/opentype/
  '';

  meta = with stdenv.lib; {
    description = "monospace font designed to be clear, pragmatic and very readable";
    homepage = https://pcaro.es/p/hermit;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

