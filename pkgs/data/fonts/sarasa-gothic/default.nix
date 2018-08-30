{ stdenv, fetchurl, p7zip }:

stdenv.mkDerivation rec {
  version = "0.6.0";
  name = "sarasa-gothic-${version}";

  package = fetchurl {
    url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${version}/sarasa-gothic-ttf-${version}.7z";
    sha256 = "00kyx03lpgycxaw0cyx96hhrx8gwkcmy3qs35q7r09y60vg5i0nv";
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
