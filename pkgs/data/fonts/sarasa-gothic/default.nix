{ stdenv, fetchurl, p7zip }:

stdenv.mkDerivation rec {
  version = "0.5.2";
  name = "sarasa-gothic-${version}";

  package = fetchurl {
    url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${version}/sarasa-gothic-ttf-${version}.7z";
    sha256 = "18ycw57k7yhrbb8njzhzk6x32xnjal61wr48qxkqy4lh9zfy0p22";
  };

  nativeBuildInputs = [ p7zip ];

  unpackPhase = ''
    7z x $package
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  meta = with stdenv.lib; {
    description = "SARASA GOTHIC is a Chinese & Japanese programming font based on Iosevka and Source Han Sans";
    homepage = https://github.com/be5invis/Sarasa-Gothic;
    license = licenses.ofl;
    maintainers = [ maintainers.ChengCat ];
    platforms = platforms.all;
    # large package, mainly i/o bound
    hydraPlatforms = [];
  };
}
