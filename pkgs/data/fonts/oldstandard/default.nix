{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "oldstandard-${version}";
  version = "2.2";

  src = fetchzip {
    stripRoot = false;
    url = "https://github.com/akryukov/oldstand/releases/download/v${version}/${name}.otf.zip";
    sha256 = "1hl78jw5szdjq9dhbcv2ln75wpp2lzcxrnfc36z35v5wk4l7jc3h";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}
    cp -v *.otf $out/share/fonts/opentype/
    cp -v FONTLOG.txt $out/share/doc/${name}
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1qwfsyp51grr56jcnkkmnrnl3r20pmhp9zh9g88kp64m026cah6n";

  meta = with stdenv.lib; {
    homepage = https://github.com/akryukov/oldstand;
    description = "An attempt to revive a specific type of Modern style of serif typefaces";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
