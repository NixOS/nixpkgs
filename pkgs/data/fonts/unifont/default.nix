{ stdenv, fetchurl, mkfontscale, mkfontdir }:

stdenv.mkDerivation rec {
  name = "unifont-${version}";
  version = "10.0.06";

  ttf = fetchurl {
    url = "mirror://gnu/unifont/${name}/${name}.ttf";
    sha256 = "1h4scl4l6503n8ghzd35dxfbai773csjrgdziqm86334zdj9g6k6";
  };

  pcf = fetchurl {
    url = "mirror://gnu/unifont/${name}/${name}.pcf.gz";
    sha256 = "0ypkmwyfrsnag69h1c0mx89ranz4f6jc9y1sqkpq2rbzg64maik0";
  };

  nativeBuildInputs = [ mkfontscale mkfontdir ];

  phases = "installPhase";

  installPhase =
    ''
      mkdir -p $out/share/fonts $out/share/fonts/truetype
      cp -v ${pcf} $out/share/fonts/unifont.pcf.gz
      cp -v ${ttf} $out/share/fonts/truetype/unifont.ttf
      cd $out/share/fonts
      mkfontdir
      mkfontscale
    '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1qz7qr6lrwcn47vn0hbbgqnhz3agdl7q7x4l4yd5ard0idv3jj98";

  meta = with stdenv.lib; {
    description = "Unicode font for Base Multilingual Plane";
    homepage = http://unifoundry.com/unifont.html;

    # Basically GPL2+ with font exception.
    license = http://unifoundry.com/LICENSE.txt;
    maintainers = [ maintainers.rycee maintainers.vrthra ];
    platforms = platforms.all;
  };
}
