{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "iosevka-${version}";
  version = "1.12.5";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/iosevka-pack-${version}.zip";
    sha256 = "0s3g6mk0ngwsrw9h9dqinb50cd9i8zhqdcmmh93fhyf4d87yfwyi";
  };

  sourceRoot = ".";

  installPhase = ''
    fontdir=$out/share/fonts/iosevka

    mkdir -p $fontdir
    cp -v iosevka-* $fontdir
  '';

  meta = with stdenv.lib; {
    homepage = "http://be5invis.github.io/Iosevka/";
    downloadPage = "https://github.com/be5invis/Iosevka/releases";
    description = ''
      Slender monospace sans-serif and slab-serif typeface inspired by Pragmata
      Pro, M+ and PF DIN Mono, designed to be the ideal font for programming.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.cstrahan ];
  };
}
