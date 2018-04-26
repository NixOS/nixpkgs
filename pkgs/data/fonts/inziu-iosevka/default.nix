{ stdenv, fetchurl, p7zip }:

stdenv.mkDerivation rec {
  version = "1.13.2";
  name = "inziu-iosevka-${version}";

  package = fetchurl {
    url = "http://7xpdnl.dl1.z0.glb.clouddn.com/inziu-iosevka-ttfs-${version}.7z";
    sha256 = "1i7qqcv1x6s1xkp687wq79zqg9ly6a7l5mnmg1iqgfgcbglgjbaw";
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
    description = "Inziu Iosevka font";
    homepage = https://be5invis.github.io/Iosevka/inziu;
    # license is clarified here: https://github.com/be5invis/Iosevka/issues/265
    license = licenses.ofl;
    maintainers = [ maintainers.ChengCat ];
    platforms = platforms.all;
    # large package, mainly i/o bound
    hydraPlatforms = [];
  };
}
